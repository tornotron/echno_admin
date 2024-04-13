import 'package:echno_attendance/camera/display_picture_screen.dart';
import 'package:echno_attendance/camera/take_picture_screen.dart';
import 'package:echno_attendance/employee/bloc/employee_bloc.dart';
import 'package:echno_attendance/employee/bloc/employee_event.dart';
import 'package:echno_attendance/employee/bloc/employee_state.dart';
import 'package:echno_attendance/employee/screens/hr_screens/hr_dashboard.dart';
import 'package:echno_attendance/employee/screens/homepage_screen.dart';
import 'package:echno_attendance/employee/utilities/employee_role.dart';
import 'package:echno_attendance/leave_module/screens/leave_status_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeStateManagementWidget extends StatefulWidget {
  const EmployeeStateManagementWidget({super.key});

  @override
  State<EmployeeStateManagementWidget> createState() =>
      _EmployeeStateManagementWidgetState();
}

class _EmployeeStateManagementWidgetState
    extends State<EmployeeStateManagementWidget> {
  @override
  Widget build(BuildContext context) {
    context.read<EmployeeBloc>().add(const EmployeeInitializeEvent());
    return BlocConsumer<EmployeeBloc, EmployeeState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is EmployeeInitializedState) {
            final currentEmployee = context.select((EmployeeBloc bloc) {
              return bloc.currentEmployee;
            });
            if (currentEmployee.employeeRole == EmployeeRole.hr) {
              return const HRDashboardScreen();
            } else {
              return const HomePage();
            }
          } else if (state is EmployeeProfileState) {
            return const HomePage();
          } else if (state is EmployeeHomeState) {
            return const HomePage();
          } else if (state is HrHomeState) {
            return const HRDashboardScreen();
          } else if (state is EmployeeLeavesState) {
            return const LeaveStatusScreen();
          } else if (state is TakePictureState) {
            return TakePictureScreen(camera: state.frontCamera);
          } else if (state is DisplayPictureState) {
            return DisplayPictureScreen(imagePath: state.imagePath);
          } else if (state is AttendanceAlreadyMarkedState) {
            return const HomePage();
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
