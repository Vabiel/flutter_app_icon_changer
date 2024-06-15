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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Icon changer example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _changeIcon(CustomIcons.first.iconName),
                child: const Text('Change to Icon 1'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _changeIcon(CustomIcons.second.iconName),
                child: const Text('Change to Icon 2'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _changeIcon(CustomIcons.byDefault.iconName),
                child: const Text('Change to Default Icon'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changeIcon(String? iconName) async {
    try {
      await _flutterCustomIconChangerPlugin.changeIcon(iconName);
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
}
