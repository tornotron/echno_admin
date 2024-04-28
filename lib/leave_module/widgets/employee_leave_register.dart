import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/utilities/employee_role.dart';
import 'package:echno_attendance/leave_module/widgets/register_stream_builder.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class EmployeeLeaveRegister extends StatefulWidget {
  const EmployeeLeaveRegister({super.key, required this.currentEmployee});

  final Employee currentEmployee;

  @override
  State<EmployeeLeaveRegister> createState() => _EmployeeLeaveRegisterState();
}

class _EmployeeLeaveRegisterState extends State<EmployeeLeaveRegister> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = EchnoHelperFunctions.isDarkMode(context);
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Employee Leave Register...',
          style: Theme.of(context).textTheme.displaySmall,
          textAlign: TextAlign.left,
        ),
        Text(
          'List of all the leaves applied by the employees...',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: EchnoSize.spaceBtwSections),
        TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(EchnoSize.borderRadiusLg),
            ),
            labelText: 'Filter',
            hintText: 'Start Typing...',
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
            // Trigger filtering when the user types
            setState(() {});
          },
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        const Divider(height: EchnoSize.dividerHeight),
        leaveRegisterStreamBuilder(
          isDarkMode: isDark,
          searchController: _searchController,
          context: context,
        ),
      ],
    );

    if (widget.currentEmployee.employeeRole != EmployeeRole.hr) {
      content = Center(
        child: Text(
          'You are not authorized to access this Page. Please contact HR',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      );
    }

    return content;
  }
}
