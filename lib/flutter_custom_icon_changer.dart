
import 'flutter_custom_icon_changer_platform_interface.dart';

class FlutterCustomIconChanger {
  Future<String?> getPlatformVersion() {
    return FlutterCustomIconChangerPlatform.instance.getPlatformVersion();
  }
}
