import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/site_module/bloc/site_bloc.dart';
import 'package:echno_attendance/site_module/bloc/site_event.dart';
import 'package:echno_attendance/site_module/models/site_model.dart';
import 'package:echno_attendance/task_module/services/task_service.dart';
import 'package:echno_attendance/task_module/utilities/task_status.dart';
import 'package:echno_attendance/task_module/widgets/task_home_widgets/task_home_header.dart';
import 'package:echno_attendance/task_module/widgets/task_home_widgets/task_home_stream.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskHomeScreen extends StatefulWidget {
  final SiteOffice siteOffice;
  final int? index;
  const TaskHomeScreen({
    required this.siteOffice,
    this.index,
    super.key,
  });

  @override
  State<TaskHomeScreen> createState() => _TaskHomeScreenState();
}

class _TaskHomeScreenState extends State<TaskHomeScreen> {
  final taskService = TaskService.firestoreTasks();
  int? _selectedIndex;
  late SiteOffice siteOffice;
  late Map<TaskStatus, int> _taskCounts;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index ?? 1;
    siteOffice = widget.siteOffice;
  }

  @override
  Widget build(context) {
    final isDark = EchnoHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: EchnoAppBar(
        leadingIcon: Icons.arrow_back_ios_new,
        leadingOnPressed: () {
          context.read<SiteBloc>().add(SiteHomeEvent(siteOffice: siteOffice));
        },
        title: Text(
          'Task Manager',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: FutureBuilder<Map<TaskStatus, int>>(
        future: taskService.getSiteTaskCounts(
            siteOffice: widget.siteOffice.siteOfficeName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          } else {
            if (!snapshot.hasData || snapshot.data == null) {
              _taskCounts = {
                TaskStatus.onHold: 0,
                TaskStatus.inProgress: 0,
                TaskStatus.todo: 0,
                TaskStatus.completed: 0,
              };
            } else {
              _taskCounts = snapshot.data!;
            }
            return Padding(
              padding: CustomPaddingStyle.defaultPaddingWithAppbar,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TaskHomeHeader(siteOffice: siteOffice),
                  const SizedBox(height: EchnoSize.spaceBtwSections),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CupertinoSlidingSegmentedControl(
                          thumbColor: isDark
                              ? EchnoColors.selectedNavDark
                              : EchnoColors.selectedNavLight,
                          children: {
                            0: Text(
                                'On Hold (${_taskCounts[TaskStatus.onHold]!})'),
                            1: Text(
                                'Ongoing (${_taskCounts[TaskStatus.inProgress]!})'),
                            2: Text(
                                'Upcoming (${_taskCounts[TaskStatus.todo]!})'),
                            3: Text(
                                'Completed (${_taskCounts[TaskStatus.completed]!})'),
                          },
                          groupValue: _selectedIndex,
                          onValueChanged: (int? index) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: EchnoSize.spaceBtwItems),
                  const Divider(height: EchnoSize.dividerHeight),
                  const SizedBox(height: EchnoSize.spaceBtwItems),
                  TaskHomeStreamWidget(
                    siteOffice: siteOffice,
                    taskService: taskService,
                    selectedIndex: _selectedIndex!,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
