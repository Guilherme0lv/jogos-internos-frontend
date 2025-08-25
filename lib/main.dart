import 'package:flutter/material.dart';
import 'package:projeto_web/dependencies/injector.dart';
import 'package:projeto_web/my_app.dart';

void main() async {
  await injector();
  runApp(const MyApp());
}