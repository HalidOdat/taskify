import 'package:flutter/material.dart';
import 'package:taskify/models/task.dart';
import 'package:taskify/routes/auth_route.dart';
import 'package:taskify/routes/calendar_route.dart';
import 'package:taskify/routes/route_not_found_route.dart';
import 'package:taskify/routes/task_add_route.dart';
import 'package:taskify/routes/task_edit_route.dart';
import 'package:taskify/routes/tasks_route.dart';

class Routes {
  static const start = '/';
  static const taskAdd = '/taskAdd/';
  static const taskEdit = '/taskEdit/';
  static const calendar = '/calendar/';
  static const login = '/login/';
  static const register = '/register/';

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
      case taskEdit:
        return MaterialPageRoute(
          builder: (context) => TaskEditRoute(
            task: routeSettings.arguments as Task,
          ),
        );
      case calendar:
        return MaterialPageRoute(
          builder: (context) => CalendarRoute(
            tasks: routeSettings.arguments as List<Task>,
          ),
        );
      case login:
        return MaterialPageRoute(
          builder: (context) => const AuthRoute(isLogin: true),
        );
      case register:
        return MaterialPageRoute(
          builder: (context) => const AuthRoute(isLogin: false),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const RouteNotFoundRoute(),
        );
    }
  }
}
