import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/services/employee_service.dart';
import 'package:echno_attendance/employee/utilities/employee_role.dart';
import 'package:echno_attendance/leave_module/models/leave_model.dart';
import 'package:echno_attendance/leave_module/services/leave_services.dart';
import 'package:echno_attendance/leave_module/utilities/leave_status.dart';
import 'package:echno_attendance/leave_module/utilities/leave_type.dart';
import 'package:echno_attendance/leave_module/widgets/leave_form_field.dart';
import 'package:echno_attendance/utilities/popups/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveApprovalForm extends StatefulWidget {
  const LeaveApprovalForm({
    super.key,
    required this.leave,
  });

  final Leave leave;
  @override
  State<LeaveApprovalForm> createState() => _LeaveApprovalFormState();
}

class _LeaveApprovalFormState extends State<LeaveApprovalForm> {
  final _leaveHandler = LeaveService.firestoreLeave();
  late Leave leave;
  late final Employee currentEmployee;
  LeaveStatus? selectedLeaveStatus;
  final TextEditingController _remarksController = TextEditingController();

  Future<void> _fetchCurrentEmployee() async {
    final employee = await EmployeeService.firestore().currentEmployee;
    setState(() {
      currentEmployee = employee;
    });
  }

  @override
  void initState() {
    super.initState();
    leave = widget.leave;
    selectedLeaveStatus = leave.leaveStatus;
    _fetchCurrentEmployee();
    _remarksController.text = leave.remarks!;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Leave Sanction Form...',
          style: Theme.of(context).textTheme.displaySmall,
          textAlign: TextAlign.left,
        ),
        Text(
          'Update the status of the applied leave here...',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: EchnoSize.spaceBtwSections),
        const Divider(height: EchnoSize.dividerHeight),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        LeaveFormField(
          mainLabel: 'Employee Name',
          isReadOnly: true,
          hintText: currentEmployee.employeeName,
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        LeaveFormField(
          mainLabel: 'Employee ID',
          isReadOnly: true,
          hintText: currentEmployee.employeeId,
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        LeaveFormField(
          mainLabel: 'Leave From',
          isReadOnly: true,
          hintText: DateFormat('dd-MM-yyyy').format(leave.fromDate),
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        LeaveFormField(
          mainLabel: 'Leave Till',
          isReadOnly: true,
          hintText: DateFormat('dd-MM-yyyy').format(leave.toDate),
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        LeaveFormField(
          mainLabel: 'Leave Type',
          isReadOnly: true,
          hintText: getLeaveTypeName(leave.leaveType),
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        LeaveFormField(
          mainLabel: 'Remarks',
          isReadOnly: true,
          maxLines: null,
          minLines: 3,
          controller: _remarksController,
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        Text(
          'Leave Status',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 5.0),
        DropdownButtonFormField<LeaveStatus>(
          value: selectedLeaveStatus,
          onChanged: (LeaveStatus? newValue) {
            setState(() {
              selectedLeaveStatus = newValue;
            });
          },
          items: LeaveStatus.values.map((LeaveStatus status) {
            String statusName = getLeaveStatusName(status);
            return DropdownMenuItem<LeaveStatus>(
              value: status, // Use enum value here
              child: Text(statusName),
            );
          }).toList(),
          decoration: const InputDecoration(
            hintText: 'Select Leave Status',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              await _leaveHandler.updateLeaveStatus(
                  leaveId: leave.leaveId,
                  newStatus: selectedLeaveStatus.toString().split('.').last);
              if (context.mounted) {
                EchnoSnackBar.successSnackBar(
                    context: context,
                    title: 'Success...',
                    message:
                        'The Leave Status has been updated successfully...');
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Update Leave Status',
            ),
          ),
        ),
      ],
    );

    if (currentEmployee.employeeRole != EmployeeRole.hr) {
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
