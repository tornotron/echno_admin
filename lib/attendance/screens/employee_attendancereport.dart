import 'package:echno_attendance/attendance/screens/daily_report.dart';
import 'package:echno_attendance/attendance/screens/monthlyreport.dart';
import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/employee/hr_bloc/hr_bloc.dart';
import 'package:echno_attendance/employee/hr_bloc/hr_event.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  bool showMainContent = true;

  @override
  void dispose() {
    super.dispose();
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 200,
            width: double.infinity,
            //padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showMainContent = true;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Get Monthly Report',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showMainContent = false;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Get Daily Report',
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = EchnoHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: EchnoAppBar(
        leadingIcon: Icons.arrow_back_ios_new,
        leadingOnPressed: () {
          context.read<HrBloc>().add(const HrDashboardEvent());
        },
        title: Text('Attendance Report',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: showMainContent ? MonthlyReport() : const DailyReport(),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          _showBottomSheet(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            "Report Type",
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? EchnoColors.white : EchnoColors.white),
          ),
        ),
      ),
    );
  }
}
