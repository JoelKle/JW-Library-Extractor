# Android JW Library data extractor

*Rescue my JW Library @ Android personal data!*


This script extracts the personal data (notes, tags, highlights, favorites, and bookmarks) from *JW Library on Android*. Especially **useful if your JW Library can no longer be opened** and you are unable to backup within the app.

It's using the `adb backup` command to create a full backup of JW Library. After that it extracts the `userData.db` containing your personal data.

A new `.jwlibrary` file will be created a uploaded back to your `Download` folder on your device.

## Requirements

- Linux machine to run the script on (Ubuntu, Debian, ...)
- USB cable to connect your phone/tablet to the PC
- Enabled `Developer Options` and `USB Debugging` on your phone/tablet
- `Android Debug Bridge (adb)` tool installed on your PC

## HowTo

1. Download the script from this repo
2. Make it executable (`$chmod a+x jwlibrary_extractor.sh`)
3. Run the script

```
$ ./jwlibrary_extractor.sh
```

## Other

The concept can also be used for a script that runs under Windows.

Ideas, Issues and Pull Requests are very welcome :)
