import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_custom_icon_changer_platform_interface.dart';

/// An implementation of [FlutterCustomIconChangerPlatform] that uses method channels.
class MethodChannelFlutterCustomIconChanger
    extends FlutterCustomIconChangerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_custom_icon_changer');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool?> changeIcon(String? iconName) async {
    final icon = Platform.isIOS ? iconName : {'iconName': iconName};
    try {
      return methodChannel.invokeMethod('changeIcon', icon);
    } on PlatformException catch (e) {
      debugPrint("Failed to change icon: '${e.message}'.");
    }
    return null;
  }
}
