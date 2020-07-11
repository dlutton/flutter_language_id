import 'dart:async';

import 'package:flutter/services.dart';

typedef void ErrorHandler(dynamic message);
typedef void VoidCallback(dynamic message);

// Provides Platform specific ML Google Language Identification services
class FlutterLanguageIdentification {
  static const MethodChannel _channel =
      const MethodChannel('flutter_language_identification');

  ErrorHandler errorHandler;
  VoidCallback successHandler;
  VoidCallback failedHandler;

  FlutterLanguageIdentification() {
    _channel.setMethodCallHandler(platformCallHandler);
  }

  /// [Future] which invokes the platform specific method for Identify Language
  Future<dynamic> identifyLanguage(String text) =>
      _channel.invokeMethod('identifyLanguage', text);

  /// [Future] which invokes the platform specific method for Identify Possible Languages
  Future<dynamic> identifyPossibleLanguages(String text) =>
      _channel.invokeMethod('identifyPossibleLanguages', text);

  void setSuccessHandler(VoidCallback callback) {
    successHandler = callback;
  }

  void setFailedHandler(VoidCallback callback) {
    failedHandler = callback;
  }

  void setErrorHandler(ErrorHandler handler) {
    errorHandler = handler;
  }

  /// Platform listeners
  Future platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "identifyPossibleLanguages.onSuccess":
        if (successHandler != null) {
          successHandler(call.arguments);
        }
        break;
      case "identifyPossibleLanguages.onError":
        if (errorHandler != null) {
          errorHandler(call.arguments);
        }
        break;
      case "identifyLanguage.onSuccess":
        if (successHandler != null) {
          successHandler(call.arguments);
        }
        break;
      case "identifyLanguage.onError":
        if (errorHandler != null) {
          errorHandler(call.arguments);
        }
        break;
      case "identifyLanguage.onFailed":
        if (failedHandler != null) {
          failedHandler(call.arguments);
        }
        break;
      default:
        print('Unknowm method ${call.method}');
    }
  }
}
