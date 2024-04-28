import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/services/employee_service.dart';
import 'package:echno_attendance/leave_module/widgets/employee_leave_register.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/material.dart';

class LeaveRegisterScreen extends StatelessWidget {
  const LeaveRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EchnoAppBar(
        leadingIcon: Icons.arrow_back_ios_new,
        leadingOnPressed: () {
          Navigator.pop(context);
        },
        title: Text('Leave Register',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: FutureBuilder<Employee>(
        future: EmployeeService.firestore().currentEmployee,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Padding(
              padding: CustomPaddingStyle.defaultPaddingWithAppbar,
              child: EmployeeLeaveRegister(
                currentEmployee: snapshot.data!,
              ),
            );
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
