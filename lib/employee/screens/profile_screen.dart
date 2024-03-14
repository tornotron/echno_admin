import 'package:echno_attendance/constants/colors_string.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/services/employee_service.dart';
import 'package:echno_attendance/employee/utilities/employee_role.dart';
import 'package:echno_attendance/employee/widgets/profile_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const EdgeInsetsGeometry containerPadding =
      EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final Employee currentEmployee;

  Future<void> _fetchCurrentEmployee() async {
    final employee = await EmployeeService.firestore().currentEmployee;
    setState(() {
      currentEmployee = employee;
    });
  }

  @override
  void initState() {
    _fetchCurrentEmployee();
    super.initState();
  }

  get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  @override
  Widget build(context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor:
                  isDarkMode ? echnoLightBlueColor : echnoBlueColor),
          backgroundColor: isDarkMode ? echnoLightBlueColor : echnoBlueColor,
          title: const Text('Profile'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: ProfileScreen.containerPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ProfileFieldsWidget(
                    title: 'Employee Name',
                    value: currentEmployee.employeeName,
                    icon: Icons.person_outlined),
                const Divider(),
                ProfileFieldsWidget(
                    title: 'Employee ID',
                    value: currentEmployee.employeeId,
                    icon: Icons.tag),
                const Divider(),
                ProfileFieldsWidget(
                    title: 'Email',
                    value: currentEmployee.companyEmail,
                    icon: Icons.email_outlined),
                const Divider(),
                ProfileFieldsWidget(
                    title: 'Phone',
                    value: currentEmployee.phoneNumber,
                    icon: Icons.phone_outlined),
                const Divider(),
                ProfileFieldsWidget(
                    title: 'Designation',
                    value: getEmloyeeRoleName(currentEmployee.employeeRole),
                    icon: Icons.work_outline),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
