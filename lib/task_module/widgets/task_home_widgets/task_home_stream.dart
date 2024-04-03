import 'package:echno_attendance/task_module/models/task_model.dart';
import 'package:echno_attendance/task_module/screens/task_details_screen.dart';
import 'package:echno_attendance/task_module/services/task_service.dart';
import 'package:echno_attendance/task_module/utilities/task_status.dart';
import 'package:echno_attendance/task_module/utilities/task_ui_helpers.dart';
import 'package:echno_attendance/task_module/widgets/task_card.dart';
import 'package:flutter/material.dart';

class TaskHomeStreamWidget extends StatelessWidget {
  const TaskHomeStreamWidget({
    super.key,
    required this.taskService,
    required int selectedIndex,
  }) : _selectedIndex = selectedIndex;

  final TaskService taskService;
  final int _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Task>>(
      stream: taskService.streamTasksBySiteOffice(siteOffice: 'Ernakulam'),
      builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No Task Found...!',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          );
        } else {
          List<Task>? tasks = snapshot.data;
          TaskStatus selectedCategory =
              TaskUiHelpers.getSelectedCategory(_selectedIndex);
          tasks =
              tasks?.where((task) => task.status == selectedCategory).toList();
          if (tasks == null || tasks.isEmpty) {
            return Center(
              child: Text(
                'No Task With This Status...!',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final taskData = tasks?[index];
                  return InkWell(
                    child: TaskCard(taskData),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return TaskDetailsScreen(task: taskData);
                      }));
                    },
                  );
                },
              ),
            );
          }
        }
      },
    );
  }
}
