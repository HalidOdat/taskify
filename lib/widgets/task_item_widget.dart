import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/blocs/task_bloc.dart';
import 'package:taskify/models/task.dart';

class TaskItemWidget extends StatelessWidget {
  final Task task;
  const TaskItemWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    Widget tags;
    if (task.tags.isEmpty) {
      tags = const Text("", style: TextStyle(fontSize: 15));
    } else {
      tags = Wrap(
        children: task.tags
            .map(
              (tag) => Chip(
                label: Text(tag),
                labelPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            )
            .map((chip) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: chip,
                ))
            .toList(),
      );
    }

    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              task.description,
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
      // leading: Text("test"),
      trailing: IconButton(
        icon: const Icon(Icons.check),
        onPressed: () {
          context.read<TaskBloc>().add(TaskRemoveEvent(task: task));
        },
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          tags,
          Text(
            task.due?.toUtc().toString().substring(0, 16) ?? "",
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
