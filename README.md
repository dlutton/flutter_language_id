# Language Identification

A flutter plugin to identify language using [Google's ML Kit](https://developers.google.com/ml-kit/language/identification). (Swift,Java)

## Features

- [x] Android, iOS
  - [x] identify language
  - [x] identify possible languages

To use this plugin :

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
