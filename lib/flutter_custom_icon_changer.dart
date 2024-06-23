import 'package:flutter/foundation.dart';

import 'flutter_custom_icon_changer_platform_interface.dart';

class FlutterCustomIconChanger {
  final AppIconsSet iconsSet;

  FlutterCustomIconChanger({required this.iconsSet}) {
    _setAvailableIcons();
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

  Future<void> _setAvailableIcons() {
    return FlutterCustomIconChangerPlatform.instance.setAvailableIcons(iconsSet);
  }

  @visibleForTesting
  Future<void> testSetAvailableIcons() {
    return _setAvailableIcons();
  }
}
