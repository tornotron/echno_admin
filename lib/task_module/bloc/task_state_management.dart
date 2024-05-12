import 'package:echno_attendance/task_module/bloc/task_bloc.dart';
import 'package:echno_attendance/task_module/bloc/task_state.dart';
import 'package:echno_attendance/task_module/screens/add_task_screen.dart';
import 'package:echno_attendance/task_module/screens/task_details_screen.dart';
import 'package:echno_attendance/task_module/screens/task_home_screen.dart';
import 'package:echno_attendance/task_module/screens/update_task_progress_screen.dart';
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
        } else if (state is AddTaskState) {
          return AddTaskScreen(siteOffice: state.siteOffice);
        } else if (state is TaskDetailsState) {
          return TaskDetailsScreen(
            siteOffice: state.siteOffice,
            task: state.task,
          );
        } else if (state is UpdateTaskState) {
          return UpdateTaskScreen(
            siteOffice: state.siteOffice,
            task: state.task,
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
