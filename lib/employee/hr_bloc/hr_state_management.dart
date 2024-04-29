import 'package:echno_attendance/attendance/screens/employee_attendancereport.dart';
import 'package:echno_attendance/employee/hr_bloc/hr_bloc.dart';
import 'package:echno_attendance/employee/hr_bloc/hr_state.dart';
import 'package:echno_attendance/employee/screens/hr_screens/employee_register_screen.dart';
import 'package:echno_attendance/leave_module/screens/leave_register_screen.dart';
import 'package:echno_attendance/site_module/bloc/site_bloc.dart';
import 'package:echno_attendance/site_module/bloc/site_state_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:echno_attendance/employee/screens/hr_screens/hr_dashboard_screen.dart';

class HrStateManagement extends StatefulWidget {
  const HrStateManagement({super.key});

  @override
  State<HrStateManagement> createState() => _HrStateManagementState();
}

class _HrStateManagementState extends State<HrStateManagement> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HrBloc, HrState>(
      builder: (context, state) {
        if (state is HrDashboardState) {
          return const HRDashboardScreen();
        } else if (state is HrNewEmployeeRegisterState) {
          return const EmployeeRegisterScreen();
        } else if (state is HrAttendanceReportState) {
          return const AttendanceReportScreen();
        } else if (state is HrLeaveRegisterState) {
          return const LeaveRegisterScreen();
        } else if (state is HrSiteManagementState) {
          return BlocProvider(
            create: (context) => SiteBloc(),
            child: const SiteStateManagement(),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
