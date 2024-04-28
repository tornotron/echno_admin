import 'package:echno_attendance/site_module/models/site_model.dart';
import 'package:echno_attendance/task_module/screens/add_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskHomeHeader extends StatelessWidget {
  const TaskHomeHeader({
    super.key,
    required this.siteOffice,
  });

  final SiteOffice siteOffice;

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
                return AddTaskScreen(
                  siteOffice: siteOffice,
                );
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
