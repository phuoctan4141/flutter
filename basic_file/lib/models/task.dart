// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Task {
  String description;
  bool complete;

  Task({this.description = '', this.complete = false});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'complete': complete,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      description: map['description'] as String,
      complete: map['complete'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);
}
