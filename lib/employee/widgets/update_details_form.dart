import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/utilities/employee_role.dart';
import 'package:flutter/material.dart';

class UpdateDetailsForm extends StatelessWidget {
  const UpdateDetailsForm({
    super.key,
    required this.employee,
    required this.employeeIdController,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.onEmployeeNameChanged,
    required this.onCompanyEmailChanged,
    required this.onPhoneNumberChanged,
    required this.onEmployeeRoleChanged,
    required this.onEmployeeStatusChanged,
    required this.updateEmployeeDetails,
  });

  final TextEditingController employeeIdController;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final Employee? employee;
  final void Function() onEmployeeNameChanged;
  final void Function() onCompanyEmailChanged;
  final void Function() onPhoneNumberChanged;
  final void Function(EmployeeRole?) onEmployeeRoleChanged;
  final void Function(bool) onEmployeeStatusChanged;
  final void Function() updateEmployeeDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                (EchnoSize.borderRadiusLg),
              ),
            ),
          ),
          onChanged: (value) {
            onEmployeeNameChanged();
          },
        ),
        const SizedBox(height: EchnoSize.spaceBtwInputFields),
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email-ID',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                (EchnoSize.borderRadiusLg),
              ),
            ),
          ),
          onChanged: (value) {
            onCompanyEmailChanged();
          },
        ),
        const SizedBox(height: EchnoSize.spaceBtwInputFields),
        TextFormField(
          controller: phoneController,
          decoration: InputDecoration(
            labelText: 'Mobie Number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                (EchnoSize.borderRadiusLg),
              ),
            ),
          ),
          onChanged: (value) {
            onPhoneNumberChanged();
          },
        ),
        const SizedBox(height: EchnoSize.spaceBtwInputFields),
        DropdownButtonFormField<EmployeeRole>(
          value: employee?.employeeRole ?? EmployeeRole.emp,
          onChanged: (EmployeeRole? newValue) {
            onEmployeeRoleChanged(newValue);
          },
          items: EmployeeRole.values.map((EmployeeRole role) {
            String roleName = getEmloyeeRoleName(role);
            return DropdownMenuItem<EmployeeRole>(
                value: role, // Use enum value here
                child: Text(roleName));
          }).toList(),
          decoration: const InputDecoration(
            labelText: 'Select Employee Role',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: EchnoColors.grey,
              width: 1.50,
            ),
            borderRadius: const BorderRadius.all(
                Radius.circular(EchnoSize.borderRadiusLg)),
          ),
          child: ListTile(
            title: Text(
              'Account Status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: Switch(
              value: employee?.employeeStatus ?? false,
              onChanged: (bool value) {
                onEmployeeStatusChanged(value);
              },
            ),
          ),
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: updateEmployeeDetails,
            child: const Text('Update Details'),
          ),
        ),
      ],
    );
  }
}
