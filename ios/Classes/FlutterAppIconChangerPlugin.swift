import Flutter
import Foundation
import UIKit

public class FlutterAppIconChangerPlugin: NSObject, FlutterPlugin {
  private var availableIcons: [AppIcon] = []

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_app_icon_changer", binaryMessenger: registrar.messenger())
    let instance = FlutterAppIconChangerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "changeIcon":
      if let args = call.arguments as? [String: Any], let iconName = args["iconName"] as? String {
        self.changeIcon(to: iconName, result: result)
      } else {
        result(FlutterError.invalidArgs("Arguments are invalid"))
      }
    case "getCurrentIcon":
        let currentIcon = self.getCurrentIcon()
        result(currentIcon)
    case "isSupported":
        let isSupported = self.isSupported()
        result(isSupported)
    case "setAvailableIcons":
        if let args = call.arguments as? [String: Any], let iconsArray = args["icons"] as? [[String: Any]] {
            self.setAvailableIcons(iconsArray)
            result(nil)
        } else {
            result(FlutterError.invalidArgs("Arguments is invalid"))
        }

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func changeIcon(to iconName: String?, result: @escaping FlutterResult) {
      guard UIApplication.shared.supportsAlternateIcons else {
          print("Changing the icon is not supported on this device.")
          result(FlutterError.iconChangeNotSupported())
          return
      }

      var defaultIcon: String? = nil

      guard let iconName = iconName else {
        setIcon(icon: defaultIcon, result: result)
        return
      }

      if let iconToChange = availableIcons.first(where: { $0.icon == iconName }) {
          if iconToChange.isDefaultIcon {
              setIcon(icon: defaultIcon, result: result)
          } else {
              setIcon(icon: iconToChange.icon, result: result)
          }
      } else {
          setIcon(icon: defaultIcon, result: result)
          result(FlutterError.iconNotFound("Icon \(iconName) not found"))
      }
  }

  private func setIcon(icon iconName: String?, result: @escaping FlutterResult) {

    UIApplication.shared.setAlternateIconName(iconName) { error in
        if let error = error {
            print("Error when changing icon: \(error.localizedDescription)")
            result(FlutterError.iconChangeFailed(error.localizedDescription))
        } else {
            print("The icon has been successfully changed.")
            result(true)
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

  private func setAvailableIcons(_ iconsArray: [[String: Any]]) {
    availableIcons = iconsArray.compactMap { AppIcon(from: $0) }
  }
}

struct AppIcon {
    let icon: String
    let isDefaultIcon: Bool

    init?(from dictionary: [String: Any]) {
        guard let icon = dictionary["icon"] as? String,
              let isDefaultIcon = dictionary["isDefaultIcon"] as? Bool else {
            return nil
        }
        self.icon = icon
        self.isDefaultIcon = isDefaultIcon
    }

    var description: String {
        return "AppIcon(icon: \(icon), isDefaultIcon: \(isDefaultIcon))"
    }
}

extension FlutterError {
    static func invalidArgs(_ message: String, details: Any? = nil) -> FlutterError {
        return FlutterError(code: "INVALID_ARGS", message: message, details: details);
    }

    static func iconChangeNotSupported() -> FlutterError {
        return FlutterError(code: "IS_NOT_SUPPORTED", message: "Changing the icon is not supported on this device.", details: nil);
    }

    static func iconNotFound(_ message: String, details: Any? = nil) -> FlutterError {
        return FlutterError(code: "ICON_NOT_FOUND", message: message, details: details);
    }

    static func iconChangeFailed(_ message: String, details: Any? = nil) -> FlutterError {
        return FlutterError(code: "ICON_CHANGE_FAILED", message: message, details: details);
    }
}
