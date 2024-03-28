import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/employee/bloc/employee_bloc.dart';
import 'package:echno_attendance/employee/bloc/employee_event.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/widgets/profile_widgets/profile_form.dart';
import 'package:echno_attendance/employee/widgets/profile_widgets/profile_picture.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const EdgeInsetsGeometry containerPadding =
      EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final Employee currentEmployee;

  @override
  Widget build(BuildContext context) {
    final isDark = EchnoHelperFunctions.isDarkMode(context);
    final currentEmployee = context.select((EmployeeBloc bloc) {
      return bloc.currentEmployee;
    });
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: EchnoAppBar(
          leadingIcon: Icons.arrow_back_ios_new,
          leadingOnPressed: () {
            context.read<EmployeeBloc>().add(const EmployeeHomeEvent());
          },
          title: Text(
            'Profile',
            style: Theme.of(context).textTheme.headlineSmall?.apply(
                  color: isDark ? EchnoColors.black : EchnoColors.white,
                ),
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
                EmployeeProfilePhoto(
                  currentEmployee: currentEmployee,
                  isDark: isDark,
                ),
                EmployeeProfileForm(
                  currentEmployee: currentEmployee,
                  isDark: isDark,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
