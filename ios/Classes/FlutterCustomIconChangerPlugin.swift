import Flutter
import UIKit

public class FlutterCustomIconChangerPlugin: NSObject, FlutterPlugin {
  private var availableIcons: [String] = []

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_custom_icon_changer", binaryMessenger: registrar.messenger())
    let instance = FlutterCustomIconChangerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "changeIcon":
        if let args = call.arguments as? [String: Any] {
            let iconName = args["iconName"] as? String
            self.changeIcon(to: iconName)
            result(true)
        } else {
            result(FlutterError.invalidArgs("Arguments is invalid"))
        }
    case "getCurrentIcon":
        let currentIcon = self.getCurrentIcon()
        result(currentIcon)
    case "isSupported":
        let isSupported = self.isSupported()
        result(isSupported)
    case "setAvailableIcons":
        if let args = call.arguments as? [String: Any], let icons = args["icons"] as? [String] {
            self.setAvailableIcons(icons)
            result(nil)
        } else {
            result(FlutterError.invalidArgs("Arguments is invalid"))
        }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func changeIcon(to iconName: String?) {
      guard UIApplication.shared.supportsAlternateIcons else {
          print("Changing the icon is not supported on this device.")
          return
      }

      UIApplication.shared.setAlternateIconName(iconName) { error in
          if let error = error {
              print("Error when changing icon: \(error.localizedDescription)")
          } else {
              print("The icon has been successfully changed.")
          }
      }
  }

  private func getCurrentIcon() -> String? {
      if let alternateIconName = UIApplication.shared.alternateIconName {
          return alternateIconName
      } else {
          return nil
      }
  }

  private func isSupported() -> Bool {
    return UIApplication.shared.supportsAlternateIcons
  }

  private func setAvailableIcons(_ icons: [String]) {
    availableIcons = icons
  }
}

extension FlutterError {
    static func invalidArgs(_ message: String, details: Any? = nil) -> FlutterError {
        return FlutterError(code: "INVALID_ARGS", message: message, details: details);
    }
}