import 'package:flutter/material.dart';
import 'package:taskify/models/task.dart';
import 'package:taskify/routes/calendar_route.dart';
import 'package:taskify/routes/route_not_found_route.dart';
import 'package:taskify/routes/task_add_route.dart';
import 'package:taskify/routes/tasks_route.dart';

class Routes {
  static const start = '/';
  static const taskAdd = '/taskAdd/';
  static const calendar = '/calendar/';

  static Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case start:
        return MaterialPageRoute(
          builder: (context) => const TasksRoute(),
        );
      case taskAdd:
        return MaterialPageRoute(
          builder: (context) => const TaskAddRoute(),
        );
      case calendar:
        return MaterialPageRoute(
          builder: (context) => CalendarRoute(
            tasks: routeSettings.arguments as List<Task>,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const RouteNotFoundRoute(),
        );
    }
  }
}
