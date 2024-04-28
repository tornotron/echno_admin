import 'package:echno_attendance/employee/hr_bloc/hr_bloc.dart';
import 'package:echno_attendance/employee/hr_bloc/hr_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:echno_attendance/employee/screens/hr_screens/hr_dashboard.dart';

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
