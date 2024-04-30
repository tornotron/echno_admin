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
  final _taskProvider = TaskService.firestoreTasks();

  int? _selectedIndex;

  get currentEmployee => widget.currentEmployee;

  final TextEditingController _searchController = TextEditingController();

  bool isLoading = false;
  int onHoldCount = 0;
  int onGoingCount = 0;
  int upComingCount = 0;
  int completedCount = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index ?? 1;
    _updateTaskCounts();
  }

  Future<void> _updateTaskCounts() async {
    setState(() {
      isLoading = true;
    });
    final taskCountMap = await _taskProvider.getEmployeeTaskCounts(
        assignedEmployee: currentEmployee.employeeId);
    setState(() {
      onHoldCount = taskCountMap[TaskStatus.onHold] ?? 0;
      onGoingCount = taskCountMap[TaskStatus.onGoing] ?? 0;
      upComingCount = taskCountMap[TaskStatus.upcoming] ?? 0;
      completedCount = taskCountMap[TaskStatus.completed] ?? 0;
      isLoading = false;
    });
  }

  @override
  Widget build(context) {
    final isDark = EchnoHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
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
                  EmployeeTaskStreamWidget(
                    employeeId: widget.currentEmployee!.employeeId,
                    taskProvider: _taskProvider,
                    searchController: _searchController,
                    selectedIndex: _selectedIndex!,
                  ),
                ],
              ),
            ),
    );
  }
}
