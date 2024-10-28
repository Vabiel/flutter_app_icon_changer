import 'package:flutter_app_icon_changer/flutter_app_icon_changer.dart';
import 'package:flutter_app_icon_changer_example/src/models/custom_icons/custom_icons.dart';

/// A custom implementation of [AppIconsSet] using predefined [CustomIcon] values.
class CustomIconsSet extends AppIconsSet {
  CustomIconsSet() : super(iconsSet: CustomIcons.values);
}
