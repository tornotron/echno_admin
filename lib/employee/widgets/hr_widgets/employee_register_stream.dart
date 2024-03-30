import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/services/hr_employee_service.dart';
import 'package:echno_attendance/employee/utilities/employee_role.dart';
import 'package:echno_attendance/employee/widgets/hr_widgets/employee_card.dart';
import 'package:flutter/material.dart';

Widget employeeRegisterStreamBuilder({
  required bool isDarkMode,
  required TextEditingController searchController,
  required BuildContext context,
}) {
  final employeeService = HrEmployeeService.firestore();
  return Expanded(
    child: StreamBuilder<List<Employee>>(
      stream: employeeService.getAllEmployees(siteOfficeName: null),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No Employee Data Found...',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          );
        } else {
          // List of employees
          final employees = snapshot.data!.toList();

          // Filter leaves based on search query
          final filteredEmployees = employees.where((employee) {
            final searchQuery = searchController.text.toLowerCase();
            return employee.employeeName.toLowerCase().contains(searchQuery) ||
                employee.employeeId.toLowerCase().contains(searchQuery) ||
                getEmloyeeRoleName(employee.employeeRole)
                    .toString()
                    .toLowerCase()
                    .contains(searchQuery) ||
                employee.companyEmail.toLowerCase().contains(searchQuery) ||
                employee.phoneNumber.toLowerCase().contains(searchQuery);
          }).toList();

          if (filteredEmployees.isEmpty) {
            return Center(
              child: Text(
                'No Employee found matching the search criteria.',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: filteredEmployees.length,
            itemBuilder: (context, index) {
              final employee = filteredEmployees[index];
              return employeeCard(employee, isDarkMode, context);
            },
          );
        }
      },
    ),
  );
}
