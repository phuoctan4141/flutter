import 'package:basic_state/providers/plan_provider.dart';
import 'package:basic_state/views/plan_creator_screen.dart';
import 'package:flutter/material.dart';

// ignore: prefer_const_constructors
void main() => runApp(PlanProvider(child: MasterPlanApp()));

// ignore: use_key_in_widget_constructors
class MasterPlanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.purple),
      // ignore: prefer_const_constructors
      home: PlanCreatorScreen(),
    );
  }
}
