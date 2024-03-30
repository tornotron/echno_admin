import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/services/hr_employee_service.dart';
import 'package:echno_attendance/employee/utilities/employee_role.dart';
import 'package:echno_attendance/employee/widgets/hr_widgets/update_details_form.dart';
import 'package:flutter/material.dart';

class UpdateDetailsFormContainer extends StatefulWidget {
  const UpdateDetailsFormContainer({super.key});

  @override
  State<UpdateDetailsFormContainer> createState() =>
      _UpdateDetailsFormContainerState();
}

class _UpdateDetailsFormContainerState
    extends State<UpdateDetailsFormContainer> {
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Employee? _employee;
  String? _employeeName;
  String? _companyEmail;
  String? _phoneNumber;
  bool? _employeeStatus;
  EmployeeRole? _employeeRole;

  void _searchEmployee(String employeeId) async {
    final employee = await HrEmployeeService.firestore()
        .readEmployee(employeeId: employeeId);

    _employeeName = employee?.employeeName;
    _companyEmail = employee?.companyEmail;
    _phoneNumber = employee?.phoneNumber;
    _employeeStatus = employee?.employeeStatus;
    _employeeRole = employee?.employeeRole;

    setState(() {
      _employee = employee;

      _nameController.text = _employeeName ?? '';
      _emailController.text = _companyEmail ?? '';
      _phoneController.text = _phoneNumber ?? '';
    });

    // Show error dialog if employee not found
    if (employee == null) {
      _showErrorDialog();
    }
  }

  // Functions to be called on change of TextFormField values
  void _onEmployeeNameChange() {
    setState(() {
      _employeeName = _nameController.text;
    });
  }

  void _onCompanyEmailChange() {
    setState(() {
      _companyEmail = _emailController.text;
    });
  }

  void _onPhoneNumberChange() {
    setState(() {
      _phoneNumber = _phoneController.text;
    });
  }

  void _onEmployeeRoleChange(EmployeeRole? newValue) {
    setState(() {
      _employeeRole = newValue ?? EmployeeRole.tc;
    });
  }

  void _onEmployeeStatusChange(bool value) {
    setState(() {
      _employeeStatus = value;
    });
  }

  // Update the employee details to firestore

  Future<void> _updateEmployeeDetails() async {
    await HrEmployeeService.firestore().updateEmployee(
      employeeId: _employeeIdController.text,
      employeeName: _employeeName,
      companyEmail: _companyEmail,
      phoneNumber: _phoneNumber,
      employeeRole: _employeeRole,
      employeeStatus: _employeeStatus,
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: EchnoColors.success,
          content: Text('Details updated successfully!'),
        ),
      );
      // Clear the fields once the details are updated successfully
      setState(() {
        _employee = null;
        _employeeIdController.clear();
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
      });
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Employee Not Found'),
          content: const Text('No employee found with the provided ID.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _employeeIdController.clear();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Update Details', style: Theme.of(context).textTheme.displaySmall),
        Text(
          'Update the personal details the employee...',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: EchnoSize.spaceBtwSections),
        TextField(
          controller: _employeeIdController,
          decoration: InputDecoration(
            labelText: 'Employee ID',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                (EchnoSize.borderRadiusLg),
              ),
            ),
          ),
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _searchEmployee(_employeeIdController.text);
            },
            child: const Text('Search'),
          ),
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        const Divider(height: EchnoSize.dividerHeight),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        if (_employee != null)
          UpdateDetailsForm(
            employee: _employee,
            employeeIdController: _employeeIdController,
            nameController: _nameController,
            emailController: _emailController,
            phoneController: _phoneController,
            onEmployeeNameChanged: _onEmployeeNameChange,
            onCompanyEmailChanged: _onCompanyEmailChange,
            onPhoneNumberChanged: _onPhoneNumberChange,
            onEmployeeRoleChanged: _onEmployeeRoleChange,
            onEmployeeStatusChanged: _onEmployeeStatusChange,
            updateEmployeeDetails: _updateEmployeeDetails,
          ),
      ],
    );
  }
}
