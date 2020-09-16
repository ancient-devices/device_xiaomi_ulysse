#!/vendor/bin/sh

CURRENT_DT_MODEL="$(cat /proc/device-tree/model)"
CORRECT_DT_MODEL="Qualcomm Technologies, Inc. MSM8940-PMI8937 MTP"
DELETE_FILE="/vendor/etc/permissions/android.hardware.fingerprint.xml"

MY_NAME="init_fingerprint"

if [ -z "$CURRENT_DT_MODEL" ]; then echo "${MY_NAME}: Cannot read Model! Aborting." ; exit 0 ; fi

if [ "$CURRENT_DT_MODEL" != "$CORRECT_DT_MODEL" ]
then
	log "${MY_NAME}: Incorrect Model! Disabling."
	if [ -f $DELETE_FILE ]
	then
		mount -o remount,rw,discard /vendor
		rm $DELETE_FILE
		mount -o remount,ro /vendor
		if [ -f $DELETE_FILE ]; then log "${MY_NAME}: Delete Failed!" ; exit 0 ; fi
	else
		log "${MY_NAME}: Already Disabled! Exiting."
	fi
else
	log "${MY_NAME}: Correct Model! Starting FP Service."
	#start vendor.fps_hal
fi

exit 0
