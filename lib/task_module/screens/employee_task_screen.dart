import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/task_module/services/task_service.dart';
import 'package:echno_attendance/task_module/utilities/task_status.dart';
import 'package:echno_attendance/task_module/widgets/employee_task_widgets/employee_task_stream.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/cupertino.dart' show CupertinoSlidingSegmentedControl;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmployeeTaskHomeScreen extends StatefulWidget {
  final Employee? currentEmployee;
  final int? index;
  const EmployeeTaskHomeScreen({
    this.currentEmployee,
    this.index,
    super.key,
  });

  @override
  State<EmployeeTaskHomeScreen> createState() => _EmployeeTaskHomeScreenState();
}

class _EmployeeTaskHomeScreenState extends State<EmployeeTaskHomeScreen> {
  final taskService = TaskService.firestoreTasks();

  int? _selectedIndex;

  get currentEmployee => widget.currentEmployee;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index ?? 1;
  }

  late Map<TaskStatus, int> _taskCounts;

  @override
  Widget build(context) {
    final isDark = EchnoHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: FutureBuilder<Map<TaskStatus, int>>(
        future: taskService.getEmployeeTaskCounts(
            assignedEmployee: currentEmployee.employeeId),
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
                TaskStatus.onGoing: 0,
                TaskStatus.upcoming: 0,
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
                  Text(
                    DateFormat.yMMMMd().format(DateTime.now()),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Today',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 20.0,
                        ),
                  ),
                  const SizedBox(height: EchnoSize.defaultSpace / 2),
                  TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      hintText: 'Search Task...',
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(EchnoSize.borderRadiusLg)),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                  SizedBox(
                      height: _searchController.text.isEmpty ? 20.0 : 10.0),
                  if (_searchController.text.isEmpty)
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
                                'On Hold (${_taskCounts[TaskStatus.onHold]!})',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              1: Text(
                                'Ongoing (${_taskCounts[TaskStatus.onGoing]!})',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              2: Text(
                                'Upcoming (${_taskCounts[TaskStatus.upcoming]!})',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              3: Text(
                                'Completed (${_taskCounts[TaskStatus.completed]!})',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
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
                  EmployeeTaskStreamWidget(
                    employeeId: widget.currentEmployee!.employeeId,
                    taskProvider: taskService,
                    searchController: _searchController,
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
