import Flutter
import UIKit

public class FlutterCustomIconChangerPlugin: NSObject, FlutterPlugin {
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
        let iconName = call.arguments as? String
        self.changeIcon(to: iconName)
        result(true)
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
}
