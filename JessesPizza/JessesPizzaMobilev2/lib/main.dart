import 'package:flutter/material.dart';
import 'package:jesses_pizza_app/app/di.dart';
import 'package:jesses_pizza_app/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const JessesPizzaApp());
}
