import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<Iterable<String>> getAudioData() async {
  final manifestJson = await rootBundle.loadString('AssetManifest.json');
  Iterable<String> audio = json
      .decode(manifestJson)
      .keys
      .where((String key) => key.startsWith('assets/audio'));
  return audio;
}
