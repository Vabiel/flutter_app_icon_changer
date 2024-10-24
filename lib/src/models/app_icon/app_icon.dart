import 'dart:io';

abstract class AppIcon {
  final String iOSIcon;
  final String androidIcon;
  final bool isDefaultIcon;

  AppIcon({
    required this.iOSIcon,
    required this.androidIcon,
    required this.isDefaultIcon,
  })  : assert(iOSIcon.isNotEmpty),
        assert(androidIcon.isNotEmpty);

  String get currentIcon => Platform.isIOS ? iOSIcon : androidIcon;

  Map<String, dynamic> get data {
    return {
      'icon': currentIcon,
      'isDefaultIcon': isDefaultIcon,
    };
  }

  @override
  String toString() {
    return 'AppIcon{iOSIcon: $iOSIcon, androidIcon: $androidIcon, isDefaultIcon: $isDefaultIcon}';
  }
}
