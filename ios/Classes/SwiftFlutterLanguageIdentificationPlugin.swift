import Flutter
import UIKit
import MLKitLanguageID

public class SwiftFlutterLanguageIdentificationPlugin: NSObject, FlutterPlugin {
  var channel = FlutterMethodChannel()
  lazy var languageId = LanguageIdentification.languageIdentification()
    
  init(channel: FlutterMethodChannel) {
    super.init()
    self.channel = channel
  }
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_language_identification", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterLanguageIdentificationPlugin(channel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "identifyLanguage":
        let text: String = call.arguments as! String
        self.identifyLanguage(text: text)
        result(1)
        break
    case "identifyPossibleLanguages":
        let text: String = call.arguments as! String
        self.identifyPossibleLanguages(text: text)
        result(1)
        break
      default:
        result(FlutterMethodNotImplemented)
    }
  }

  private func identifyLanguage(text: String) {
    languageId.identifyLanguage(for: text) { (languageTag, error) in
      if let error = error {
        self.channel.invokeMethod("identifyLanguage.onError", arguments: error)
        return
      }

      if languageTag == IdentifiedLanguage.undetermined {
        self.channel.invokeMethod("identifyLanguage.onFailed", arguments: "Undetermined Language")
        return
      }
      
      self.channel.invokeMethod("identifyLanguage.onSuccess", arguments: languageTag)
    }
  }
    
  private func identifyPossibleLanguages(text: String) {
    languageId.identifyPossibleLanguages(for: text) { (identifiedLanguages, error) in
      if let error = error {
        self.channel.invokeMethod("identifyPossibleLanguages.onError", arguments: error)
        return
      }

        let text =
        "Identified Languages:\n"
        + identifiedLanguages!.map {
          String(format: "(%@, %.2f)", $0.languageTag, $0.confidence)
        }.joined(separator: "\n")
      self.channel.invokeMethod("identifyPossibleLanguages.onSuccess", arguments: text)
    }
  }
}
