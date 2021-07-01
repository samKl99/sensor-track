# sensor_track

Flutter App to read data from RuuviTag and CC2541 SensorTag Texas Instruments.

## Getting Started

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Decrypt Firebase config

In order to run and build the app you need to decrypt it first:

```
gpg --batch --passphrase ${GPG_PASSPHRASE} android/app/google-services.json.gpg
```

```
gpg --batch --passphrase ${GPG_PASSPHRASE} ios/Runner/GoogleService-Info.plist.gpg
```

where `GPG_PASSPHRASE` is the passphrase that encrypts the respective file.

## Generate Code

In order to run and build the app you need to generate source code first:

```
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Login

The app offers different auth methods such as Email/Password, Google and Apple.
To view your sensor data on the IOTA data marketplace must sign in with Google, as the data marketplace only offers Google as
an authentication provider.

## Edit app launcher name
  
Edit `pubspec.yaml` and change the `flutter_launcher_name.name` value. Run following command to apply your change to
Android and iOS code:
  
```
flutter pub run flutter_launcher_name:main
```
  
## Edit app launcher icon
 
Edit `assets/launcher/logo.png`. Run following command to apply your change to Android and iOS code: 

```
flutter pub run flutter_launcher_icons:main
```

