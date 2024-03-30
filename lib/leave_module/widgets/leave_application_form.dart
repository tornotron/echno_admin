import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/leave_module_strings.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/services/employee_service.dart';
import 'package:echno_attendance/leave_module/services/leave_services.dart';
import 'package:echno_attendance/leave_module/utilities/leave_type.dart';
import 'package:echno_attendance/leave_module/widgets/date_selection_field.dart';
import 'package:echno_attendance/leave_module/widgets/leave_form_field.dart';
import 'package:echno_attendance/utilities/popups/custom_snackbar.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveApplicationForm extends StatefulWidget {
  const LeaveApplicationForm({super.key});

  @override
  State<LeaveApplicationForm> createState() => _LeaveApplicationFormState();
}

class _LeaveApplicationFormState extends State<LeaveApplicationForm> {
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final _leaveHandler = LeaveService.firestoreLeave(); // Leave related services
  final GlobalKey<FormState> _leaveFormKey = GlobalKey<FormState>();

  late final Employee currentEmployee;

  DateTime? startDate; // Starting date of leave
  DateTime? endDate; // Ending date of leave

  LeaveType?
      _selectedLeaveType; // Variable to store selected leave type using radio buttons

  // Function selects the start date of leave
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      if (picked.isBefore(DateTime.now())) {
        // Show error dialog for start date before current date
        _showErrorDialog(startDateErrorMessage);
      } else {
        setState(() {
          startDate = picked;
          _startDateController.text = DateFormat('dd-MM-yyyy').format(picked);
          endDate = null; // Reset end date when start date changes
          _endDateController.clear();
        });
      }
    }
  }

  // Function selects the end date of leave
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && startDate != null) {
      if (picked.isBefore(startDate!)) {
        _showErrorDialog(endDateErrorMessage);
      } else {
        setState(() {
          endDate = picked;
          _endDateController.text = DateFormat('dd-MM-yyyy').format(picked);
        });
      }
    }
  }

  // Function to calculate the number of days on leave
  String? calculateLeaveDays() {
    if (startDate != null && endDate != null) {
      return (endDate!.difference(startDate!).inDays + 1).toString();
    } else {
      return '-';
    }
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: EchnoColors.error),
              Text('Error'),
            ],
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentEmployee();
  }

  Future<void> _fetchCurrentEmployee() async {
    final employee = await EmployeeService.firestore().currentEmployee;
    setState(() {
      currentEmployee = employee;
    });
  }

  // Submit the leave application and clear the fields

  void _submitLeaveApplication() {
    if (_leaveFormKey.currentState!.validate()) {
      // Form is valid, submit the leave application
      _leaveHandler.applyForLeave(
        authUserId: currentEmployee.authUserId,
        employeeId: currentEmployee.employeeId,
        profilePhoto: currentEmployee.photoUrl ?? '',
        employeeName: currentEmployee.employeeName,
        appliedDate: DateTime.now(),
        fromDate: startDate ?? DateTime.now(),
        toDate: endDate ?? DateTime.now(),
        leaveType: _selectedLeaveType.toString().split('.').last,
        siteOffice: 'Site Office',
        remarks: _remarksController.text,
      );

      if (context.mounted) {
        EchnoSnackBar.successSnackBar(
            context: context,
            title: 'Success...',
            message:
                'Your leave application has been submitted successfully...');
      }
      // Clear the fields on successful submission of leave
      setState(() {
        _startDateController.clear();
        _endDateController.clear();
        _remarksController.clear();
        startDate = null;
        endDate = null;
        _selectedLeaveType = null;
      });
    }
  }

  // Validator functions

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'This date filed is required';
    }
    return null;
  }

  String? _validateLeaveType(LeaveType? value) {
    if (value == null) {
      return 'Please select a leave type';
    }
    return null;
  }

  String? _validateRemarks(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter remarks';
    }
    return null;
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _leaveFormKey,
      child: Padding(
        padding: CustomPaddingStyle.defaultPaddingWithAppbar,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              leaveApplicationScreenTitle,
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.left,
            ),
            Text(
              leaveApplicationSubtitle,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: EchnoSize.spaceBtwItems),
            const Divider(height: EchnoSize.dividerHeight),
            const SizedBox(height: EchnoSize.spaceBtwItems),

            // The immediate supervisor of the employee
            const LeaveFormField(
              mainLabel: coordinatorFieldLabel,
              isReadOnly: true,
              hintText: 'Alex Mercer', // This should be fetched from DB
            ),
            const SizedBox(height: EchnoSize.spaceBtwItems),

            // Current Date
            LeaveFormField(
              mainLabel: currentDateFieldLabel,
              isReadOnly: true,
              hintText: DateFormat('dd-MM-yyyy').format(DateTime.now()),
            ),
            const SizedBox(height: EchnoSize.spaceBtwItems),

            // Selection field the start date of leave
            CustomDateField(
              controller: _startDateController,
              label: 'Start Date',
              hintText: startDate == null
                  ? startDateFieldHint
                  : DateFormat('dd-MM-yyyy').format(startDate!),
              onTap: () {
                _selectStartDate(context);
              },
              validator: _validateDate,
            ),
            const SizedBox(height: EchnoSize.spaceBtwItems),

            // Selection field the end date of leave
            CustomDateField(
              controller: _endDateController,
              label: 'End Date',
              hintText: endDate == null
                  ? endDateFieldHint
                  : DateFormat('dd-MM-yyyy').format(endDate!),
              onTap: () {
                _selectEndDate(context);
              },
              validator: _validateDate,
            ),
            const SizedBox(height: EchnoSize.spaceBtwItems),

            // Number of days on leave calculated from start and end date
            Text(
              "$calculateDaysFieldLabel ${calculateLeaveDays()}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: EchnoSize.spaceBtwItems),

            // Dropdoen to select Leave Type
            Text(
              leaveTypeFieldLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 5.0),
            DropdownButtonFormField<LeaveType>(
              value: _selectedLeaveType,
              onChanged: (LeaveType? newValue) {
                setState(() {
                  _selectedLeaveType = newValue;
                });
              },
              items: LeaveType.values.map((LeaveType type) {
                String typeName = getLeaveTypeName(type);
                return DropdownMenuItem<LeaveType>(
                  value: type,
                  child: Text(typeName),
                );
              }).toList(),
              decoration: const InputDecoration(
                hintText: 'Select Leave Type',
                border: OutlineInputBorder(),
              ),
              validator: _validateLeaveType,
            ),
            const SizedBox(height: EchnoSize.spaceBtwItems),

            // Text field to enter remarks
            Text(
              remarksFieldLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 5.0),
            TextFormField(
              controller: _remarksController,
              minLines: 5,
              maxLines: null, // Allows for an adjustable number of lines
              decoration: const InputDecoration(
                hintText: remarksFieldHint,
                border: OutlineInputBorder(),
              ),
              validator: _validateRemarks,
            ),

            const SizedBox(height: EchnoSize.spaceBtwItems),

            // Button to submit leave application
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitLeaveApplication,
                child: const Text(
                  submitButtonLabel,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
