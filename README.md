# U Music

![Build Version](https://img.shields.io/badge/V-3.7.5-brightgreen)
![Build](https://img.shields.io/badge/Status-Stable-brightgreen)
![BuildX](https://img.shields.io/badge/FlutterChannel-Stable-blue)


![Screen Shots](https://raw.githubusercontent.com/SrilalS/U-Music/master/Screenshots/S1.png?raw=true)
![Screen Shots](https://raw.githubusercontent.com/SrilalS/U-Music/master/Screenshots/S2.png?raw=true)
![Screen Shots](https://raw.githubusercontent.com/SrilalS/U-Music/master/Screenshots/S4.png?raw=true)


An Experimental Music Player Build using Flutter.

## Download Arm64 APK

[[Download]](https://github.com/SrilalS/U-Music/releases/)


## Installation

Build the APK Using following Command.


```bash
flutter build apk
```
## Building
You will need Latest Flutter SDK (Preffered Latest Beta).
This Project is Build for SDK 29 Android.

## APIs USED
[MusixMatch](https://developer.musixmatch.com/) API (Free Plan) Used to Search for Lyrics.

### API KEYS
- APIKEYS.dart is gitIgnored for obvious Reasons.

- When Building This Project,

- Create the "APIKEYS.dart" file in "lib/Secrets" and add,

- "String musixmatchapikey = 'YOUR KEY HERE';"

## Plugins Used
This Projects Uses Following Plugins.

Path Provider : [Link To Plugin Page](https://pub.dev/packages/path_provider)

Flutter Audio Query : [Link To Plugin Page](https://pub.dev/packages/flutter_audio_query)

Audio Player : [Link To Plugin Page](https://pub.dev/packages/audioplayer)

Flutter Local Notifications : [Link To Plugin Page](https://pub.dev/packages/flutter_local_notifications)

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
