import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/colors_string.dart';
import 'package:echno_attendance/employee/hr_screens/attendance_report/monthlyreport.dart';
import 'package:echno_attendance/employee/hr_screens/attendance_report/daily_report.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  bool showMainContent = true;

  TextEditingController employeeIdController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  String employeeIdfromUI = '';
  String attendanceMonthfromUI = '';
  String attendanceYearfromUI = '';

  @override
  void dispose() {
    employeeIdController.dispose();
    monthController.dispose();
    yearController.dispose();
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
    final isDark = EchnoHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: EchnoAppBar(
        leadingIcon: Icons.arrow_back_ios_new,
        leadingOnPressed: () {
          Navigator.pop(context);
        },
        title: Text(
          'Attendance Report',
          style: Theme.of(context).textTheme.headlineSmall?.apply(
                color: isDark ? EchnoColors.black : EchnoColors.white,
              ),
        ),
      ),
      body: showMainContent
          ? MonthlyReport(
              employeeIdController: employeeIdController,
              yearController: yearController,
              employeeIdfromUI: employeeIdfromUI,
              attendanceMonthfromUI: attendanceMonthfromUI,
              attendanceYearfromUI: attendanceYearfromUI,
            )
          : const DailyReport(),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          _showBottomSheet(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: echnoBlueLightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            "Change report type",
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .apply(fontWeightDelta: 1),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
