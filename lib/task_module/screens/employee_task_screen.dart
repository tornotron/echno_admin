import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/task_module/services/task_service.dart';
import 'package:echno_attendance/task_module/widgets/employee_task_widgets/employee_task_stream.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
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

  late int _selectedIndex;

  get currentEmployee => widget.currentEmployee;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index ?? 1;
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Padding(
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
              onChanged: (value) {
                // Trigger search when the user types
                setState(() {});
              },
            ),
            SizedBox(height: _searchController.text.isEmpty ? 20.0 : 10.0),
            if (_searchController.text.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildCategoryButton(0, 'On Hold'),
                          buildCategoryButton(1, 'Ongoing'),
                          buildCategoryButton(2, 'Upcoming'),
                          buildCategoryButton(3, 'Completed'),
                        ],
                      ),
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
              selectedIndex: _selectedIndex,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryButton(int index, String text) {
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
                left: BorderSide(width: 0.1), right: BorderSide(width: 0.1))),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: EchnoColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
              ),
        ),
      ),
    );
  }
}
