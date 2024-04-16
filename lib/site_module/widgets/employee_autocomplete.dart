import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/utilities/employee_role.dart';
import 'package:flutter/material.dart';

class EmployeeAutoComplete extends StatelessWidget {
  const EmployeeAutoComplete(
      {required this.employees,
      required this.onSelectedEmployeesChanged,
      super.key});

  final List<Employee> employees;

  final void Function(Employee) onSelectedEmployeesChanged;

  @override
  Widget build(BuildContext context) {
    late TextEditingController customController;
    return Autocomplete<Employee>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable.empty();
        } else {
          return employees.where((employee) {
            return employee.employeeName
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()) ||
                getEmloyeeRoleName(employee.employeeRole)
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
          }).toList();
        }
      },
      fieldViewBuilder: (context, controller, focusNode, onEdittingComplete) {
        customController = controller;
        return TextFormField(
          controller: customController,
          focusNode: focusNode,
          onEditingComplete: onEdittingComplete,
          decoration: InputDecoration(
            hintText: 'Start typing',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.person),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                customController.clear();
              },
            ),
          ),
        );
      },
      displayStringForOption: (Employee option) =>
          '${option.employeeName} (${option.employeeId})',
      onSelected: (Employee employee) {
        onSelectedEmployeesChanged(employee);
      },
      optionsViewBuilder: (context, Function(Employee) onSelected, options) {
        return Material(
          child: ListView.separated(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final option = options.elementAt(index);
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: option.photoUrl != null
                        ? NetworkImage(option.photoUrl!)
                        : null,
                    child: option.photoUrl == null
                        ? const Icon(Icons.account_circle, size: 50)
                        : null,
                  ),
                  title: Text(option.employeeName),
                  subtitle: Text(getEmloyeeRoleName(option.employeeRole)),
                  onTap: () => onSelected(option),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: options.length),
        );
      },
    );
  }
}
