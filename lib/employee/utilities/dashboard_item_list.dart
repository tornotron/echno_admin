import 'package:echno_attendance/employee/hr_screens/add_employee.dart';
import 'package:echno_attendance/employee/hr_screens/attendance_report/employee_attendancereport.dart';
import 'package:echno_attendance/employee/hr_screens/employee_register.dart';
import 'package:echno_attendance/employee/hr_screens/update_details_screen.dart';
import 'package:echno_attendance/employee/models/dashboard_item.dart';
import 'package:echno_attendance/leave_module/screens/leave_register.dart';
import 'package:flutter/material.dart';

class DashboardItemList {
  static List<DashboardItem> getHrDashboardItems(
      {required BuildContext context}) {
    return <DashboardItem>[
      DashboardItem(
        icon: Icons.person_add_alt_1_rounded,
        text: 'Add Employee',
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddNewEmployee();
          }));
        },
      ),
      DashboardItem(
        icon: Icons.checklist_rtl_rounded,
        text: 'Update Details',
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const UpdateEmployeeDetailsScreen();
          }));
        },
      ),
      DashboardItem(
        icon: Icons.person_search_rounded,
        text: 'Employee Register',
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const EmployeeRegisterScreen();
          }));
        },
      ),
      DashboardItem(
        icon: Icons.location_history_rounded,
        text: 'Attendance Report',
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AttendanceReportScreen();
          }));
        },
      ),
      DashboardItem(
        icon: Icons.app_registration_rounded,
        text: 'Leave Register',
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const LeaveRegisterScreen();
          }));
        },
      ),
      DashboardItem(
        icon: Icons.settings_rounded,
        text: 'Settings',
        onTap: () {},
      ),
    ];
  }
}