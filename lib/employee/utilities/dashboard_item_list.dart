import 'package:echno_attendance/employee/hr_bloc/hr_bloc.dart';
import 'package:echno_attendance/employee/utilities/dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:echno_attendance/employee/hr_bloc/hr_event.dart';

class DashboardItemList {
  static List<DashboardItem> getHrDashboardItems(
      {required BuildContext context}) {
    return <DashboardItem>[
      DashboardItem(
        icon: Icons.person_search_rounded,
        text: 'Employee Register',
        onTap: () {
          context.read<HrBloc>().add(const HrNewEmployeeRegisterEvent());
        },
      ),
      DashboardItem(
        icon: Icons.location_history_rounded,
        text: 'Attendance Report',
        onTap: () {
          context.read<HrBloc>().add(const HrAttendanceReportEvent());
        },
      ),
      DashboardItem(
        icon: Icons.app_registration_rounded,
        text: 'Leave Register',
        onTap: () {
          context.read<HrBloc>().add(const HrLeaveRegisterEvent());
        },
      ),
      DashboardItem(
        icon: Icons.location_on_outlined,
        text: 'Site Management',
        onTap: () {
          context.read<HrBloc>().add(const HrSiteManagementEvent());
        },
      ),
    ];
  }
}
