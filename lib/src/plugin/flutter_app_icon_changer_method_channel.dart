import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/models.dart';
import 'flutter_app_icon_changer_platform_interface.dart';

/// An implementation of [FlutterAppIconChangerPlatform] that uses method channels.
class MethodChannelFlutterAppIconChanger extends FlutterAppIconChangerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_app_icon_changer');

  /// Changes the app icon to the specified [iconName].
  ///
  /// If [iconName] is `null`, the default icon is used.
  /// Returns `true` if the icon was successfully changed.
  @override
  Future<bool?> changeIcon(String? icon) {
    return methodChannel.invokeMethod<bool>('changeIcon', {'iconName': icon});
  }

  /// Retrieves the name of the current app icon.
  ///
  /// May return `true` if a default icon is set.
  @override
  Future<String?> getCurrentIcon() {
    return methodChannel.invokeMethod<String>('getCurrentIcon');
  }

  /// Checks if changing the app icon is supported on the current platform.
  @override
  Future<bool> isSupported() async {
    final isSupported = await methodChannel.invokeMethod<bool>('isSupported');
    return isSupported ?? false;
  }

  /// Sets the available icons for the plugin.
  @override
  Future<void> setAvailableIcons(AppIconsSet iconsSet) async {
    final dataSet = iconsSet.toDataSet();
    await methodChannel.invokeMethod('setAvailableIcons', {'icons': dataSet});
  }
}
