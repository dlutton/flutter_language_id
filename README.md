# Language Identification

[![pub package](https://img.shields.io/pub/v/flutter_language_identification.svg?style=for-the-badge&colorB=green)](https://pub.dartlang.org/packages/flutter_language_identification)

A flutter plugin to identify language using [Google's ML Kit](https://developers.google.com/ml-kit/language/identification). (Swift,Java)

## Features

- [x] Android, iOS
  - [x] identify language
  - [x] identify possible languages

To use this plugin :

### iOS

Google's ML Kit requires a minimum deployment target of 10.0. You can add the line `platform :ios, '10.0'` in your iOS project `Podfile`.

You may also need to update your app's deployment target to 10.0 using Xcode. Otherwise, you may see compilation errors.

### Flutter

- add the dependency to your pubspec.yaml

```yaml
  dependencies:
    flutter:
      sdk: flutter
    flutter_language_identification:
```

- instantiate FlutterLanguageIdentification

```dart
FlutterLanguageIdentification languageIdentification = FlutterLanguageIdentification();
```

### identifyLanguage, identifyPossibleLanguages

```dart
Future _identifyLanguage() async{
    await languageIdentification.identyLanguage("Hello World");
}

Future _identifyPossibleLanguages() async{
    await languageIdentification.identifyPossibleLanguages("Hello World");
}
```

### Listening for platform calls to receive results

```dart
languageIdentification.setSuccessHandler((message) {
    setState(() {
    print(message);
    _result = message;
    });
});

languageIdentification.setErrorHandler((message) {
    setState(() {
    print(message);
    });
});

languageIdentification.setFailedHandler((message) {
    setState(() {
    print(message);
    _result = message;
    });
});
```
