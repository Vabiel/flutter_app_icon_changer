import 'package:flutter_app_icon_changer/src/models/app_icon/app_icon.dart';

abstract class AppIconsSet {
  final List<AppIcon> iconsSet;

  AppIconsSet({
    required this.iconsSet,
  })  : assert(iconsSet.isNotEmpty, ''),
        assert(iconsSet.any((e) => e.isDefaultIcon), '');

  List<Map<String, dynamic>> toDataSet() {
    return iconsSet.map((e) => e.data).toList();
  }

  @override
  String toString() {
    return 'AppIconsSet{iconsSet: $iconsSet}';
  }
}
