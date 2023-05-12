import 'package:flutter/material.dart';
import 'package:qrtest/display.dart';
import 'package:qrtest/scan.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Scan(),
      'display': (context) => Display(),
    },
  ));
}
