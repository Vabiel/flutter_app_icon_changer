import 'package:flutter_app_icon_changer/flutter_app_icon_changer.dart';

class CustomIcons {
  static final purpleIcon = PurpleIcon();
  static final redIcon = RedIcon();
  static final defaultIcon = DefaultIcon();
}

sealed class CustomIcon extends AppIcon {
  final String previewPath;

  CustomIcon({
    required this.previewPath,
    required super.iOSIcon,
    required super.androidIcon,
    required super.isDefaultIcon,
  });

  factory CustomIcon.fromString(String? icon) {
    if (icon == null) return CustomIcons.defaultIcon;

    return CustomIcon.values.firstWhere(
      (e) => e.iOSIcon == icon || e.androidIcon == icon,
      orElse: () => CustomIcons.defaultIcon,
    );
  }

  static final List<CustomIcon> values = [
    CustomIcons.purpleIcon,
    CustomIcons.redIcon,
    CustomIcons.defaultIcon,
  ];
}

final class RedIcon extends CustomIcon {
  RedIcon()
      : super(
          iOSIcon: 'AppIcon1',
          androidIcon: 'MainActivityAlias1',
          previewPath: 'assets/icons/icon1.png',
          isDefaultIcon: false,
        );
}

final class PurpleIcon extends CustomIcon {
  PurpleIcon()
      : super(
    iOSIcon: 'AppIcon2',
    androidIcon: 'MainActivityAlias2',
    previewPath: 'assets/icons/icon2.png',
    isDefaultIcon: false,
  );
}

final class DefaultIcon extends CustomIcon {
  DefaultIcon()
      : super(
          iOSIcon: 'AppIcon',
          androidIcon: 'MainActivity',
          previewPath: 'assets/icons/default_icon.png',
          isDefaultIcon: true,
        );
}
