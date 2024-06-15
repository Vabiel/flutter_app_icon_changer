import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_custom_icon_changer/flutter_custom_icon_changer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterCustomIconChangerPlugin = FlutterCustomIconChanger();

  var _currentIcon = CustomIcons.byDefault;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    final currentIcon = await _flutterCustomIconChangerPlugin.getCurrentIcon();

    if (!mounted) return;

    setState(() {
      _currentIcon = CustomIcons.fromString(currentIcon);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Icon changer example'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              const Spacer(),
              Text('currentIcon: $_currentIcon'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _changeIcon(CustomIcons.first),
                child: const Text('Change first Icon'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _changeIcon(CustomIcons.second),
                child: const Text('Change second Icon'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _changeIcon(CustomIcons.byDefault),
                child: const Text('Change default Icon'),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changeIcon(CustomIcons icon) async {
    final iconName = icon.iconName;
    try {
      await _flutterCustomIconChangerPlugin.changeIcon(iconName);
      setState(() {
        _currentIcon = icon;
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to change icon: '${e.message}'.");
    }
  }
}

enum CustomIcons {
  first('AppIcon1', 'icon1'),
  second('AppIcon2', 'icon2'),
  byDefault(null, null);

  final String? _iosIconName;
  final String? _androidIconName;

  const CustomIcons(this._iosIconName, this._androidIconName);

  String? get iconName => Platform.isIOS ? _iosIconName : _androidIconName;

  factory CustomIcons.fromString(String? icon) {
    return CustomIcons.values.firstWhere(
      (e) => e._iosIconName == icon || e._androidIconName == icon,
      orElse: () => CustomIcons.byDefault,
    );
  }
}
