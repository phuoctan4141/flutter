// ignore_for_file: unused_field

import 'package:basic_state/controllers/plan_controller.dart';
import 'package:flutter/material.dart';

class PlanProvider extends InheritedWidget {
  final _controller = PlanController();

  PlanProvider({Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static PlanController of(BuildContext context) {
    PlanProvider? provider =
        context.dependOnInheritedWidgetOfExactType<PlanProvider>();
    return provider!._controller;
  }
}
