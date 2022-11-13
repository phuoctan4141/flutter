// ignore_for_file: prefer_final_fields, unrelated_type_equality_checks, avoid_print, no_leading_underscores_for_local_identifiers, unused_element

import 'dart:convert';

import 'package:basic_file/models/plan.dart';
import 'package:basic_file/models/task.dart';
import 'package:basic_file/providers/file_manager.dart';
import 'package:flutter/material.dart';

class FileController extends ChangeNotifier {
  late Plan _plan = Plan();

  Plan get plan => _plan;

  Future fetandcreateJsonFile() async {
    FileManager().createJsonFile();
  }

  Future fetandsetPlan() async {
    try {
      await FileManager().readJsonFile().then((jsonContents) {
        for (dynamic task in jsonContents) {
          _plan.tasks.add(Task.fromMap(task));
        }
      });
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  Future writeTask(dynamic _plan) async {
    this._plan = _plan;
    final jsonText = plan.tasks.map(((task) => task.toMap())).toList();

    await FileManager().writeJsonFile(jsonText);

    notifyListeners();
  }

  Future createNewTask([String? description]) async {
    if (description == null || description.isEmpty) {
      description = 'New Task';
    }

    description = _checkForDuplicates(
        _plan.tasks.map((task) => task.description), description);

    _plan.tasks.add(Task(description: description));

    writeTask(plan);

    notifyListeners();
  }

  Future deteteTask(index) async {
    _plan.tasks.removeWhere((element) => element == _plan.tasks[index]);

    writeTask(plan);

    notifyListeners();
  }

  String _checkForDuplicates(Iterable<String> items, String text) {
    final duplicatedCount = items.where((item) => item.contains(text)).length;
    if (duplicatedCount > 0) {
      text += ' ${duplicatedCount + 1}';
    }

    return text;
  }

  String convertToJSON(Plan plan) {
    String json = '[';
    for (var task in plan.tasks) {
      json += jsonEncode(task);
    }
    json += ']';

    return json;
  }
}
