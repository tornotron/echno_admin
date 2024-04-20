import 'package:echno_attendance/auth/bloc/auth_bloc.dart';
import 'package:echno_attendance/auth/bloc/auth_event.dart';
import 'package:echno_attendance/auth/utilities/alert_dialogue.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/employee/bloc/employee_bloc.dart';
import 'package:echno_attendance/employee/bloc/employee_event.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/utilities/employee_role.dart';
import 'package:echno_attendance/employee/widgets/profile_widgets/profile_field_widget.dart';
import 'package:echno_attendance/employee/widgets/profile_widgets/profile_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeProfileForm extends StatelessWidget {
  const EmployeeProfileForm({
    super.key,
    required this.currentEmployee,
    required this.isDark,
  });

  final Employee currentEmployee;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        ListTile(
          leading: const Icon(Icons.work_outline),
          title: Text(
            'Sites',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 15.0),
          ),
          trailing: SizedBox(
            width: 130.0,
            child: Wrap(
              spacing: 8.0,
              alignment: WrapAlignment.end,
              children: [
                Text(
                  currentEmployee.sites!.isNotEmpty
                      ? currentEmployee.sites?.join(', ') ?? 'No site assigned'
                      : 'No site assigned',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 15.0),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
        ),
        const Divider(),
        ProfileMenuWidget(
            isDark: isDark,
            icon: Icons.settings,
            title: 'Settings',
            onPressed: () {}),
        ProfileMenuWidget(
          isDark: isDark,
          icon: Icons.leak_add_outlined,
          title: 'Leaves',
          onPressed: () {
            context.read<EmployeeBloc>().add(
                const EmployeeProfileEvent(section: 'profile_leave_section'));
          },
        ),
        ProfileMenuWidget(
            isDark: isDark,
            title: 'Log Out',
            textColor: EchnoColors.error,
            icon: Icons.logout_rounded,
            onPressed: () async {
              final authBloc = context.read<AuthBloc>();
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout) {
                authBloc.add(const AuthLogOutEvent());
              }
            }),
      ],
    );
  }
}
