import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskify/blocs/task_bloc.dart';
import 'package:taskify/models/task.dart';
import 'package:taskify/services/camera_service.dart';
import 'package:taskify/widgets/custom_app_bar.dart';
import 'package:taskify/widgets/tags_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class TaskAddRoute extends StatefulWidget {
  const TaskAddRoute({super.key});

  @override
  State<TaskAddRoute> createState() => _TaskAddRouteState();
}

class _TaskAddRouteState extends State<TaskAddRoute> {
  TextEditingController description = TextEditingController();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final DateTime _focusedDate = DateTime.now();
  DateTime? _selectedDay;
  List<String> _tags = [];
  File? _image;

  final DateTime _firstDay =
      DateTime.now().subtract(const Duration(days: 365 * 100));
  final DateTime _lastDay = DateTime.now().add(const Duration(days: 365 * 100));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Tasks"),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: description,
                autofocus: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Description",
                ),
              ),
              TableCalendar(
                firstDay: _firstDay,
                lastDay: _lastDay,
                focusedDay: _focusedDate,
                selectedDayPredicate: (day) {
                  return _selectedDay == day;
                },
                calendarFormat: _calendarFormat,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                child: TagsWidget(
                  tags: const [],
                  onSubmit: (tags) {
                    _tags = tags;
                  },
                ),
              ),
              const SizedBox(height: 20),
              _image != null
                  ? Image.file(_image!)
                  : IconButton(
                      icon: const Icon(Icons.image),
                      onPressed: () async {
                        _image = await CameraService().takeAndSaveImage();
                        setState(() {});
                      },
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          if (description.value.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cannot add task without a description'),
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }

          if (context.mounted) {
            context.read<TaskBloc>().add(
                  TaskAddEvent(
                    task: Task(
                      uuid: const Uuid().v4(),
                      description: description.text,
                      tags: _tags,
                      due: _selectedDay,
                      status: TaskStatus.pending,
                      imagePath: _image?.path == null
                          ? null
                          : path.basename(_image!.path),
                    ),
                  ),
                );
            Navigator.pop(context);
          }
        },
        child: Icon(
          color: Theme.of(context).primaryColor,
          Icons.add_task_sharp,
          size: 50,
        ),
      ),
    );
  }
}
