#!/bin/bash

# 30-07-2022  JoelKle  1.0.0  Initial Version


set -euo pipefail

if ! command -v adb >/dev/null; then
  echo "Required command > adb < not found!"
  echo "Ubuntu/Debian: Install with $ apt install adb"
  exit 1
fi
if ! command -v zlib-flate >/dev/null; then
  echo "Required command > zlib-flate < not found!"
  echo "Ubuntu/Debian: Install with $ apt install qpdf"
  exit 1
fi

today=$(date '+%Y-%m-%d')
today_time=$(date '+%Y-%m-%dT%H:%M:%S')
today_time_underscore=$(date '+%Y-%m-%dT%H_%M_%S')

while ! (adb devices -l | grep -qoP 'model:\S+')
do
  adb devices -l
  echo "Could not found your device model"
  echo "Ensure Developer Options and USB Debugging are enabled on your device"
  echo "  Settings > Developer Options > USB Debugging > Enable"
  echo "If it's > unauthorized < confirm the message on your device"
  echo "Try again?"
  read -p
done

device_name=$(adb devices -l | grep -oP 'model:\S+' | cut -d':' -f2)
echo "Found device $device_name"
echo "Continue?"
read -p ""

echo "Start backup of JW Library on device ${device_name} ..."

folder="${device_name}_${today_time_underscore}_jwlibrary_backup"
mkdir $folder && cd $folder

echo "Check your ${device_name}. A screen should have popped up to start the backup."
echo "Do not enter a passwort!"
echo
adb backup -f org.jw.jwlibrary.mobile.ab -noapk org.jw.jwlibrary.mobile

echo
echo "Backup was successful!"
echo "Start extraction..."
echo

mkdir extracted
dd if=org.jw.jwlibrary.mobile.ab bs=24 skip=1 | zlib-flate -uncompress | tar xf - -C extracted/

cp extracted/apps/org.jw.jwlibrary.mobile/db/userData.db .

sha256sum_userdata=$(sha256sum userData.db)
device_name_manual="${device_name}_manual"
jwlibrary_filename=UserDataBackup_${today}_${device_name_manual}.jwlibrary

cat <<EOF > manifest.json
{
  "name": "UserDataBackup_${today}_${device_name_manual}",
  "creationDate": "${today}",
  "version": 1,
  "type": 0,
  "userDataBackup": {
    "userMarkCount": 1,
    "lastModifiedDate": "${today}+00:00",
    "deviceName": "${device_name_manual}",
    "databaseName": "userData.db",
    "hash": "${sha256sum_userdata}",
    "schemaVersion": 8
  }
}
EOF

zip $jwlibrary_filename userData.db manifest.json

adb push $jwlibrary_filename /storage/emulated/0/Download/

echo
echo "Pushed file $jwlibrary_filename to /storage/emulated/0/Download/ folder on your device"
echo "Start the recovery in the JW Library app!"
