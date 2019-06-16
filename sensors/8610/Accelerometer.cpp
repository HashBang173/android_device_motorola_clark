/*
 * Copyright (C) 2008 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *	  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <fcntl.h>
#include <errno.h>
#include <math.h>
#include <poll.h>
#include <unistd.h>
#include <dirent.h>
#include <sys/select.h>
#include <cutils/log.h>

#include "AccelSensor.h"
#include "sensors.h"

#define FETCH_FULL_EVENT_BEFORE_RETURN	1
#define IGNORE_EVENT_TIME				10000000

#define	EVENT_TYPE_ACCEL_X	ABS_X
#define	EVENT_TYPE_ACCEL_Y	ABS_Y
#define	EVENT_TYPE_ACCEL_Z	ABS_Z

#define ACCEL_CONVERT		((GRAVITY_EARTH) / 1024)
#define CONVERT_ACCEL_X		ACCEL_CONVERT
#define CONVERT_ACCEL_Y		ACCEL_CONVERT
#define CONVERT_ACCEL_Z		ACCEL_CONVERT

#define SYSFS_I2C_SLAVE_PATH	"/device/device/"
#define SYSFS_INPUT_DEV_PATH	"/device/"

/*****************************************************************************/

AccelSensor::AccelSensor()
	: SensorBase(NULL, "accelerometer"),
	  mEnabled(0),
	  mInputReader(4),
	  mHasPendingEvent(false),
	  mEnabledTime(0),
	  mFlushEnabled(0)
{
	mPendingEvent.version = sizeof(sensors_event_t);
	mPendingEvent.sensor = SENSORS_ACCELERATION_HANDLE;
	mPendingEvent.type = SENSOR_TYPE_ACCELEROMETER;
	memset(mPendingEvent.data, 0, sizeof(mPendingEvent.data));

	memset(&mFlushEvent, 0, sizeof(mFlushEvent));
	mFlushEvent.version = META_DATA_VERSION;
	mFlushEvent.sensor = 0;
	mFlushEvent.type = SENSOR_TYPE_META_DATA;
	mFlushEvent.reserved0 = 0;
	mFlushEvent.timestamp = 0;
	mFlushEvent.meta_data.what = META_DATA_FLUSH_COMPLETE;
	mFlushEvent.meta_data.sensor = SENSORS_ACCELERATION_HANDLE;

	if (data_fd) {
		strcpy(input_sysfs_path, "/sys/class/input/");
		strcat(input_sysfs_path, input_name);
		strcat(input_sysfs_path, SYSFS_I2C_SLAVE_PATH);
		input_sysfs_path_len = strlen(input_sysfs_path);
#ifdef TARGET_8610
		if (access(input_sysfs_path, F_OK)) {
			input_sysfs_path_len -= strlen(SYSFS_I2C_SLAVE_PATH);
			strcpy(&input_sysfs_path[input_sysfs_path_len],
					SYSFS_INPUT_DEV_PATH);
			input_sysfs_path_len += strlen(SYSFS_INPUT_DEV_PATH);
		}
#endif
		enable(0, 1);
	}
}

AccelSensor::~AccelSensor() {
	if (mEnabled) {
		enable(0, 0);
	}
}

int AccelSensor::setInitialState() {
	struct input_absinfo absinfo_x;
	struct input_absinfo absinfo_y;
	struct input_absinfo absinfo_z;
	float value;
	if (!ioctl(data_fd, EVIOCGABS(EVENT_TYPE_ACCEL_X), &absinfo_x) &&
		!ioctl(data_fd, EVIOCGABS(EVENT_TYPE_ACCEL_Y), &absinfo_y) &&
		!ioctl(data_fd, EVIOCGABS(EVENT_TYPE_ACCEL_Z), &absinfo_z)) {
		value = absinfo_x.value;
		mPendingEvent.data[0] = value * CONVERT_ACCEL_X;
		value = absinfo_y.value;
		mPendingEvent.data[1] = value * CONVERT_ACCEL_Y;
		value = absinfo_z.value;
		mPendingEvent.data[2] = value * CONVERT_ACCEL_Z;
		mHasPendingEvent = true;
	}
	return 0;
}

int AccelSensor::enable(int32_t, int en) {
	int flags = en ? 1 : 0;
	if (flags != mEnabled) {
#if 1
		int fd;
		strcpy(&input_sysfs_path[input_sysfs_path_len], "enable");
		fd = open(input_sysfs_path, O_RDWR);
		if (fd >= 0) {
			char buf[2];
			int err;
			buf[1] = 0;
			if (flags) {
				buf[0] = '1';
				mEnabledTime = getTimestamp() + IGNORE_EVENT_TIME;
			} else {
				buf[0] = '0';
			}
			err = write(fd, buf, sizeof(buf));
			close(fd);
			mEnabled = flags;
			setInitialState();
			return 0;
		}
		ALOGE("AccelSensor: failed to open %s", input_sysfs_path);
		return -1;
#else
		mEnabled = flags;
		setInitialState();
#endif
	}
	return 0;
}

bool AccelSensor::hasPendingEvents() const {
	return mHasPendingEvent;
}

int AccelSensor::setDelay(int32_t handle, int64_t delay_ns)
{
	int fd;
	int delay_ms = delay_ns / 1000000;
	strcpy(&input_sysfs_path[input_sysfs_path_len], "poll_delay");
	if(access(input_sysfs_path, F_OK) != 0)
		strcpy(&input_sysfs_path[input_sysfs_path_len], "poll");
	fd = open(input_sysfs_path, O_RDWR);
	if (fd >= 0) {
		char buf[80];
		sprintf(buf, "%d", delay_ms);
		write(fd, buf, strlen(buf)+1);
		close(fd);
		return 0;
	}
	return -1;
}

int AccelSensor::readEvents(sensors_event_t* data, int count)
{
	if (count < 1)
		return -EINVAL;

	int numEventReceived = 0;
	input_event const* event;

	if (mHasPendingEvent) {
		mHasPendingEvent = false;
		mPendingEvent.timestamp = getTimestamp();
		*data = mPendingEvent;
		return mEnabled ? 1 : 0;
	}

	if(count && mFlushEnabled) {
		mFlushEnabled = 0;
		*data++ = mFlushEvent;
		count--;
		numEventReceived++;
	}

	ssize_t n = mInputReader.fill(data_fd);
	if (n < 0)
		return n;

#if FETCH_FULL_EVENT_BEFORE_RETURN
again:
#endif
	while (count && mInputReader.readEvent(&event)) {
		int type = event->type;
		if (type == EV_ABS) {
			float value = event->value;
			if (event->code == EVENT_TYPE_ACCEL_X) {
				mPendingEvent.data[0] = value * CONVERT_ACCEL_X;
			} else if (event->code == EVENT_TYPE_ACCEL_Y) {
				mPendingEvent.data[1] = value * CONVERT_ACCEL_Y;
			} else if (event->code == EVENT_TYPE_ACCEL_Z) {
				mPendingEvent.data[2] = value * CONVERT_ACCEL_Z;
			}
		} else if (type == EV_SYN) {
			mPendingEvent.timestamp = timevalToNano(event->time);
			if (mEnabled) {
				if (mPendingEvent.timestamp >= mEnabledTime) {
					*data++ = mPendingEvent;
					numEventReceived++;
				}
				count--;
			}
		} else {
			ALOGE("AccelSensor: unknown event (type=%d, code=%d)",
					type, event->code);
		}
		mInputReader.next();
	}

#if FETCH_FULL_EVENT_BEFORE_RETURN
	/* if we didn't read a complete event, see if we can fill and
	   try again instead of returning with nothing and redoing poll. */
	if (numEventReceived == 0 && mEnabled == 1) {
		n = mInputReader.fill(data_fd);
		if (n)
			goto again;
	}
#endif

	return numEventReceived;
}

int AccelSensor::flush(int32_t handle)
{
	mFlushEnabled = 1;
	return 0;
}
