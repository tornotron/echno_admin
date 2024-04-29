import 'package:echno_attendance/leave_module/screens/site_leave_register_screen.dart';
import 'package:echno_attendance/site_module/bloc/site_bloc.dart';
import 'package:echno_attendance/site_module/bloc/site_state.dart';
import 'package:echno_attendance/site_module/screens/create_site_screen.dart';
import 'package:echno_attendance/site_module/screens/site_members_assignment_screen.dart';
import 'package:echno_attendance/site_module/screens/site_attendance_screen.dart';
import 'package:echno_attendance/site_module/screens/site_home_screen.dart';
import 'package:echno_attendance/site_module/screens/site_management_screen.dart';
import 'package:echno_attendance/task_module/screens/task_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SiteStateManagement extends StatefulWidget {
  const SiteStateManagement({super.key});

  @override
  State<SiteStateManagement> createState() => _SiteStateManagementState();
}

class _SiteStateManagementState extends State<SiteStateManagement> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SiteBloc, SiteState>(
      builder: (context, state) {
        if (state is SiteManagementDashboardState) {
          return const SiteManagementScreen();
        } else if (state is SiteHomeState) {
          return SiteHomeScreen(siteOffice: state.siteOffice);
        } else if (state is SiteCreateState) {
          return const CreateSiteScreen();
        } else if (state is SiteAttendanceReportState) {
          return SiteAttendanceReport(siteOffice: state.siteOffice);
        } else if (state is SiteLeaveRegisterState) {
          return SiteLeaveRegisterScreen(siteOffice: state.siteOffice);
        } else if (state is SiteTaskManagementState) {
          return TaskHomeScreen(siteOffice: state.siteOffice);
        } else if (state is SiteMemberManagementState) {
          return AssignSiteMembersScreen(siteOffice: state.siteOffice);
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
