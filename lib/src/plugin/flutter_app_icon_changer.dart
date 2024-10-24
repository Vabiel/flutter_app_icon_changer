import 'package:flutter/foundation.dart';

import '../models/models.dart';
import 'flutter_app_icon_changer_platform_interface.dart';

class FlutterAppIconChanger {
  final AppIconsSet iconsSet;

  FlutterAppIconChanger({required this.iconsSet}) {
    _setAvailableIcons();
  }

  Future<bool?> changeIcon(String? iconName) {
    return FlutterAppIconChangerPlatform.instance.changeIcon(iconName);
  }

  Future<String?> getCurrentIcon() {
    return FlutterAppIconChangerPlatform.instance.getCurrentIcon();
  }

  Future<bool> isSupported() {
    return FlutterAppIconChangerPlatform.instance.isSupported();
  }

  Future<void> _setAvailableIcons() {
    return FlutterAppIconChangerPlatform.instance.setAvailableIcons(iconsSet);
  }

  @visibleForTesting
  Future<void> testSetAvailableIcons() {
    return _setAvailableIcons();
  }
}
