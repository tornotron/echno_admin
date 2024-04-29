import 'package:echno_attendance/task_module/bloc/task_bloc.dart';
import 'package:echno_attendance/task_module/bloc/task_state.dart';
import 'package:echno_attendance/task_module/screens/task_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskStateManagement extends StatefulWidget {
  const TaskStateManagement({super.key});

  @override
  State<TaskStateManagement> createState() => _TaskStateManagementState();
}

class _TaskStateManagementState extends State<TaskStateManagement> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskHomeState) {
          return TaskHomeScreen(
            siteOffice: state.siteOffice,
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
