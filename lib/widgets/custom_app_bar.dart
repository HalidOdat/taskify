import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/repository/task_repository.dart';
import 'package:taskify/routes/routes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.calendar_month),
          onPressed: () async {
            final tasks = await context.read<TaskRepository>().getAll();
            if (context.mounted) {
              Navigator.of(context)
                  .pushNamed(Routes.calendar, arguments: tasks);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.login),
          onPressed: () {
            Navigator.pushNamed(context, Routes.login);
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: _signOut,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
