import 'package:echno_attendance/auth/bloc/auth_bloc.dart';
import 'package:echno_attendance/auth/bloc/auth_event.dart';
import 'package:echno_attendance/auth/utilities/alert_dialogue.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/screens/hr_screens/add_employee.dart';
import 'package:echno_attendance/employee/screens/hr_screens/update_details_screen.dart';
import 'package:echno_attendance/employee/widgets/hr_widgets/hr_drawer_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HrAppDrawer extends StatelessWidget {
  const HrAppDrawer({
    super.key,
    required this.currentEmployee,
    required this.isDark,
  });

  final Employee currentEmployee;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(currentEmployee.photoUrl ??
                        'https://www.w3schools.com/w3images/avatar2.png'),
                  ),
                  const SizedBox(height: EchnoSize.spaceBtwItems),
                  Text('HR', style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
            ),
            HrDrawerMenuItem(
                isDark: isDark,
                title: 'Add Employee',
                icon: Icons.person_add_alt_1_rounded,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const AddNewEmployee();
                  }));
                }),
            HrDrawerMenuItem(
                isDark: isDark,
                title: 'Update Employee Details',
                icon: Icons.checklist_rtl_rounded,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const UpdateEmployeeDetailsScreen();
                  }));
                }),
            HrDrawerMenuItem(
                isDark: isDark,
                title: 'Settings',
                icon: Icons.settings,
                onPressed: () {}),
            HrDrawerMenuItem(
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
        ),
      ),
    );
  }
}
