import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light/light.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskify/blocs/task_bloc.dart';
import 'package:taskify/models/task.dart';
import 'package:taskify/services/notifications.dart';
import 'package:taskify/repository/task_repository.dart';
import 'package:taskify/routes/routes.dart';
import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:taskify/theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationController.initialize();

  var preferences = await SharedPreferences.getInstance();
  runApp(MyApp(
    preferences: preferences,
  ));
}

class MyApp extends StatefulWidget {
  final SharedPreferences preferences;
  const MyApp({super.key, required this.preferences});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _luxValue = -1;
  Light? _light;
  StreamSubscription? _subscription;

  void onData(int luxValue) async {
    print("Lux value: $luxValue");
    setState(() {
      _luxValue = luxValue;
    });
  }

  void stopListening() {
    _subscription?.cancel();
  }

  void startListening() {
    _light = Light();
    try {
      _subscription = _light?.lightSensorStream.listen(onData);
    } on LightException catch (exception) {
      print(exception);
    }
  }

  @override
  void initState() {
    super.initState();
    startListening();

    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod);
  }

  void _scheduleNotification(Task task) {
    if (task.due == null) {
      return;
    }
    final due = task.due!;

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: task.uuid.hashCode,
        channelKey: "basic_channel",
        title: task.description,
        body: "You have a task due tomorrow!",
      ),
      schedule: NotificationCalendar(
        day: due.subtract(const Duration(days: 1)).day,
        month: due.subtract(const Duration(days: 1)).month,
        year: due.subtract(const Duration(days: 1)).year,
        hour: due.subtract(const Duration(days: 1)).hour,
        minute: due.subtract(const Duration(days: 1)).minute,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TaskRepository(widget.preferences),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TaskBloc>(
            create: (context) => TaskBloc(
              repository: context.read<TaskRepository>(),
            ),
          ),
        ],
        child: BlocListener<TaskBloc, TaskState>(
          listener: (context, state) {
            for (int i = 0; i < state.tasks.length; i++) {
              _scheduleNotification(state.tasks[i]);
            }
          },
          child: MaterialApp(
            title: 'Taskify',
            theme: catppuccinTheme(catppuccin.frappe),
            darkTheme: catppuccinTheme(catppuccin.macchiato),
            themeMode: _luxValue < 0
                ? ThemeMode.system
                : (_luxValue > 50 ? ThemeMode.light : ThemeMode.dark),
            onGenerateRoute: Routes.onGenerateRoute,
          ),
        ),
      ),
    );
  }
}
