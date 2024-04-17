import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/site_module/models/site_model.dart';
import 'package:echno_attendance/task_module/services/task_service.dart';
import 'package:echno_attendance/task_module/utilities/task_status.dart';
import 'package:echno_attendance/task_module/widgets/task_home_widgets/task_home_header.dart';
import 'package:echno_attendance/task_module/widgets/task_home_widgets/task_home_stream.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
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

  late int _selectedIndex;
  late SiteOffice siteOffice;
  late Map<TaskStatus, int> taskCounts;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index ?? 1;
    siteOffice = widget.siteOffice;
    _updateTaskCounts();
  }

  Future<void> _updateTaskCounts() async {
    final taskCountMap = await taskService.getSiteTaskCounts(
        siteOffice: widget.siteOffice.siteOfficeName);
    setState(() {
      taskCounts = taskCountMap;
    });
  }

  @override
  Widget build(context) {
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
      body: Padding(
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildCategoryButton(
                            0, 'On Hold', taskCounts[TaskStatus.onHold] ?? 0),
                        buildCategoryButton(1, 'Ongoing',
                            taskCounts[TaskStatus.inProgress] ?? 0),
                        buildCategoryButton(
                            2, 'Upcoming', taskCounts[TaskStatus.todo] ?? 0),
                        buildCategoryButton(3, 'Completed',
                            taskCounts[TaskStatus.completed] ?? 0),
                      ],
                    ),
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
              selectedIndex: _selectedIndex,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryButton(int index, String text, int taskCount) {
    Brightness themeMode = Theme.of(context).brightness;
    Color selectedColor = themeMode == Brightness.dark
        ? EchnoColors.selectedNavDark
        : EchnoColors.selectedNavLight;
    Color unselectedColor = EchnoColors.darkGrey;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: _selectedIndex == index ? selectedColor : unselectedColor,
          border: const Border(
            left: BorderSide(width: 0.1),
            right: BorderSide(width: 0.1),
          ),
        ),
        child: Row(
          children: [
            Text('$text ($taskCount)',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: EchnoColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    )),
          ],
        ),
      ),
    );
  }
}
