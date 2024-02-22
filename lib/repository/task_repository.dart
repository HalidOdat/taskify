import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskify/models/task.dart';

const taskKey = "tasks";

class TaskRepository {
  List<Task> tasks = [];
  SharedPreferences preferences;

  TaskRepository(this.preferences);

  Future<List<Task>> getAll() async {
    final List<String>? diskTasks = preferences.getStringList(taskKey);
    if (diskTasks == null) {
      return tasks;
    }

    tasks = diskTasks.map((e) => Task.fromJson(json.decode(e))).toList();
    return tasks;
  }

  Future<void> _save() async {
    final taskJsonList = tasks.map((e) => json.encode(e.toJson())).toList();
    await preferences.setStringList(
      taskKey,
      taskJsonList,
    );
  }

  Future<void> create(Task newTask) async {
    tasks.add(newTask);
    await _save();
  }

  Future<void> update(Task task) async {
    final index = tasks.indexWhere((e) => e.uuid == task.uuid);
    tasks[index] = task;
    await _save();
  }

  Future<void> delete(Task task) async {
    tasks.removeWhere((element) => element.uuid == task.uuid);
    await _save();
  }

  Future<List<Task>> search(String value) async {
    final text = value.toLowerCase();
    return tasks
        .where((element) => element.description.toLowerCase().contains(text))
        .toList();
  }
}
