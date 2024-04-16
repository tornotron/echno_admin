import 'package:echno_attendance/attendance/screens/employee_attendancereport.dart';
import 'package:echno_attendance/site_module/screens/site_management_screen.dart';
import 'package:echno_attendance/employee/screens/hr_screens/employee_register.dart';
import 'package:echno_attendance/employee/utilities/dashboard_item.dart';
import 'package:echno_attendance/leave_module/screens/leave_register_screen.dart';
import 'package:flutter/material.dart';

class DashboardItemList {
  static List<DashboardItem> getHrDashboardItems(
      {required BuildContext context}) {
    return <DashboardItem>[
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
        icon: Icons.location_on_outlined,
        text: 'Site Management',
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const SiteManage();
          }));
        },
      ),
    ];
  }
}
