// ignore_for_file: prefer_const_constructors

import 'package:basic_file/controllers/file_controller.dart';
import 'package:basic_file/views/plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FileController(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Json Demo',
      home: PlanScreen(),
    );
  }
}
