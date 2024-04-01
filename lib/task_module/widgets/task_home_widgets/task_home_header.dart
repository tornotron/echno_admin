import 'package:echno_attendance/task_module/screens/add_new_task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskHomeHeader extends StatelessWidget {
  const TaskHomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text('Today',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 20.0,
                    )),
          ],
        ),
        SizedBox(
          width: 130.00,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const AddTaskScreen();
              }));
            },
            child: const Text(
              '+ Add Task',
            ),
          ),
        ),
      ],
    );
  }
}
