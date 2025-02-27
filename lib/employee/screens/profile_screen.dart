import 'package:echno_attendance/employee/bloc/employee_bloc.dart';
import 'package:echno_attendance/employee/bloc/employee_state.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/widgets/profile_widgets/profile_form.dart';
import 'package:echno_attendance/employee/widgets/profile_widgets/profile_picture.dart';
import 'package:echno_attendance/utilities/helpers/device_helper.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final Employee currentEmployee;
  bool isUpdating = false;

  @override
  Widget build(BuildContext context) {
    final isDark = EchnoHelperFunctions.isDarkMode(context);
    final currentEmployee = context.select((EmployeeBloc bloc) {
      return bloc.currentEmployee;
    });
    return Material(
      child: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeProfileState) {
            isUpdating = state.isUpdating;
          }
          return SingleChildScrollView(
            child: Padding(
              padding: CustomPaddingStyle.defaultPaddingWithAppbar,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  EmployeeProfilePhoto(
                    currentEmployee: currentEmployee,
                    isDark: isDark,
                    isUpdating: isUpdating,
                  ),
                  EmployeeProfileForm(
                    currentEmployee: currentEmployee,
                    isDark: isDark,
                  ),
                  SizedBox(
                    height: DeviceUtilityHelpers.getBottomNavigationBarHeight(),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
