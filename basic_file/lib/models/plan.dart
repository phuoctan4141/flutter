import 'package:basic_file/models/task.dart';

class Plan {
  List<Task> tasks = [];

  int get completeCount => tasks.where((task) => task.complete).length;

  String get completenessMessage =>
      '$completeCount out of ${tasks.length} tasks';
}
