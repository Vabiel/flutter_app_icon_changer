import 'flutter_custom_icon_changer_platform_interface.dart';

class FlutterCustomIconChanger {
  Future<String?> getPlatformVersion() {
    return FlutterCustomIconChangerPlatform.instance.getPlatformVersion();
  }

  Future<bool?> changeIcon(String? iconName) {
    return FlutterCustomIconChangerPlatform.instance.changeIcon(iconName);
  }

  Future<String?> getCurrentIcon() {
    return FlutterCustomIconChangerPlatform.instance.getCurrentIcon();
  }

  Future<bool> isSupported() {
    return FlutterCustomIconChangerPlatform.instance.isSupported();
  }

  Future<void> setAvailableIcons(List<String> icons) {
    return FlutterCustomIconChangerPlatform.instance.setAvailableIcons(icons);
  }
}
