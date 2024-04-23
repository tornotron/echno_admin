import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/site_module/models/site_model.dart';
import 'package:echno_attendance/task_module/services/task_service.dart';
import 'package:echno_attendance/task_module/utilities/task_status.dart';
import 'package:echno_attendance/task_module/widgets/task_home_widgets/task_home_header.dart';
import 'package:echno_attendance/task_module/widgets/task_home_widgets/task_home_stream.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  late Map<TaskStatus, int> taskCounts;
  bool isLoading = false;
  int onHoldCount = 0;
  int onGoingCount = 0;
  int upComingCount = 0;
  int completedCount = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index ?? 1;
    siteOffice = widget.siteOffice;
    _updateTaskCounts();
  }

  Future<void> _updateTaskCounts() async {
    setState(() {
      isLoading = true;
    });
    final taskCountMap = await taskService.getSiteTaskCounts(
        siteOffice: widget.siteOffice.siteOfficeName);
    setState(() {
      onHoldCount = taskCountMap[TaskStatus.onHold] ?? 0;
      onGoingCount = taskCountMap[TaskStatus.inProgress] ?? 0;
      upComingCount = taskCountMap[TaskStatus.todo] ?? 0;
      completedCount = taskCountMap[TaskStatus.completed] ?? 0;
      isLoading = false;
    });
  }

  @override
  Widget build(context) {
    final isDark = EchnoHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: EchnoAppBar(
        leadingIcon: Icons.arrow_back_ios_new,
        leadingOnPressed: () {
          Navigator.pop(context);
        },
        title: Text(
          'Task Manager',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
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
                            0: Text('On Hold ($onHoldCount)'),
                            1: Text('Ongoing ($onGoingCount)'),
                            2: Text('Upcoming ($upComingCount)'),
                            3: Text('Completed ($completedCount)'),
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
                    siteOffice: siteOffice.siteOfficeName,
                    taskService: taskService,
                    selectedIndex: _selectedIndex!,
                  ),
                ],
              ),
            ),
    );
  }
}
