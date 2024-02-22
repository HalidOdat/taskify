import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:taskify/models/task.dart';
import 'package:taskify/repository/task_repository.dart';

@immutable
abstract class TaskEvent {}

final class TaskFetchEvent extends TaskEvent {}

final class TaskAddEvent extends TaskEvent {
  final Task task;
  TaskAddEvent({required this.task});
}

final class TaskRemoveEvent extends TaskEvent {
  final Task task;
  TaskRemoveEvent({required this.task});
}

final class TaskToggleEvent extends TaskEvent {
  final Task task;
  TaskToggleEvent({required this.task});
}

final class TaskSearchEvent extends TaskEvent {
  final String text;
  TaskSearchEvent({required this.text});
}

class TaskState {
  final List<Task> tasks;
  const TaskState({required this.tasks});
}

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc({required this.repository}) : super(const TaskState(tasks: [])) {
    on<TaskFetchEvent>((event, emit) async {
      final tasks = await repository.getAll();
      emit(TaskState(tasks: tasks));
    });

    on<TaskAddEvent>((event, emit) async {
      await repository.create(event.task);
      final tasks = await repository.getAll();
      emit(TaskState(tasks: tasks));
    });

    on<TaskRemoveEvent>((event, emit) async {
      await repository.delete(event.task);
      final tasks = await repository.getAll();
      emit(TaskState(tasks: tasks));
    });

    on<TaskToggleEvent>((event, emit) async {
      event.task.status = event.task.status.toggle();
      await repository.update(event.task);
      final tasks = await repository.getAll();
      emit(TaskState(tasks: tasks));
    });

    on<TaskSearchEvent>((event, emit) async {
      final tasks = await repository.search(event.text);
      emit(TaskState(tasks: tasks));
    });
  }
}
