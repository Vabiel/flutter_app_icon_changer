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
                onPressed: () => _changeIcon('icon1'),
                child: const Text('Change to Icon 1'),
              ),
              ElevatedButton(
                onPressed: () => _changeIcon('icon2'),
                child: const Text('Change to Icon 2'),
              ),
              ElevatedButton(
                onPressed: () => _changeIcon(null),
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
