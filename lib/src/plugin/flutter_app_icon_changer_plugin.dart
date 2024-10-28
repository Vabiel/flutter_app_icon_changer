import 'package:flutter/foundation.dart';

import '../models/models.dart';
import 'flutter_app_icon_changer_platform_interface.dart';

/// A plugin class for changing the app icon.
///
/// It interfaces with the platform-specific implementations to change the app icon at runtime.
class FlutterAppIconChangerPlugin {
  /// The set of available app icons.
  final AppIconsSet iconsSet;

  FlutterAppIconChangerPlugin({required this.iconsSet}) {
    _setAvailableIcons();
  }

  /// Changes the app icon to the specified [iconName].
  ///
  /// If [iconName] is `null`, the default icon is used.
  /// Returns `true` if the icon was successfully changed.
  Future<bool?> changeIcon(String? iconName) {
    return FlutterAppIconChangerPlatform.instance.changeIcon(iconName);
  }

  /// Retrieves the name of the current app icon.
  ///
  /// May return `true` if a default icon is set.
  Future<String?> getCurrentIcon() {
    return FlutterAppIconChangerPlatform.instance.getCurrentIcon();
  }

  /// Checks if changing the app icon is supported on the current platform.
  Future<bool> isSupported() {
    return FlutterAppIconChangerPlatform.instance.isSupported();
  }

  /// Sets the available icons for the plugin.
  ///
  /// This method communicates with the platform-specific code to provide the list of available icons.
  Future<void> _setAvailableIcons() {
    return FlutterAppIconChangerPlatform.instance.setAvailableIcons(iconsSet);
  }

  /// Exposes [_setAvailableIcons] for testing purposes.
  @visibleForTesting
  Future<void> testSetAvailableIcons() {
    return _setAvailableIcons();
  }
}
