import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/models.dart';
import 'flutter_app_icon_changer_platform_interface.dart';

/// An implementation of [FlutterAppIconChangerPlatform] that uses method channels.
class MethodChannelFlutterAppIconChanger extends FlutterAppIconChangerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_app_icon_changer');

  @override
  Future<bool?> changeIcon(String? icon) async {
    try {
      return methodChannel.invokeMethod<bool>('changeIcon', {'iconName': icon});
    } on PlatformException catch (e) {
      debugPrint("Failed to change icon: $icon\n'${e.message}'.");
    }
    return null;
  }

  @override
  Future<String?> getCurrentIcon() async {
    try {
      return methodChannel.invokeMethod<String>('getCurrentIcon');
    } on PlatformException catch (e) {
      debugPrint("Failed to get current icon: '${e.message}'.");
    }
    return null;
  }

  @override
  Future<bool> isSupported() async {
    try {
      final isSupported = await methodChannel.invokeMethod<bool>('isSupported');
      return isSupported ?? false;
    } on PlatformException catch (e) {
      debugPrint("Failed to check if icon change is supported: '${e.message}'.");
      return false;
    }
  }

  @override
  Future<void> setAvailableIcons(AppIconsSet iconsSet) async {
    try {
      final dataSet = iconsSet.toDataSet();
      await methodChannel.invokeMethod('setAvailableIcons', {'icons': dataSet});
    } on PlatformException catch (e) {
      debugPrint("Failed to set available icons: $iconsSet\n'${e.message}'.");
    }
  }
}
