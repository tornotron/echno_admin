import 'package:echno_attendance/attendance/domain/firestore/attendance_firestore_handler.dart';
import 'package:echno_attendance/attendance/services/attendance_controller.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/employee/bloc/employee_bloc.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/widgets/attcard_monthly.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MainAttendanceReportScreen extends StatefulWidget {
  const MainAttendanceReportScreen({super.key});

  @override
  State<MainAttendanceReportScreen> createState() =>
      _MainAttendanceReportScreenState();
}

class _MainAttendanceReportScreenState
    extends State<MainAttendanceReportScreen> {
  Future<Map<String, dynamic>> getAttData(
      {required String employeeId,
      required String attendanceMonth,
      required String attYear}) async {
    final attendanceData =
        await AttendanceDatabaseController(AttendanceFirestoreRepository())
            .fetchFromDatabase(
                employeeId: employeeId,
                attendanceMonth: attendanceMonth,
                attYear: attYear);

    if (attendanceData.isEmpty) {
      return {};
    }

    return {
      'attendanceData': attendanceData,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = EchnoHelperFunctions.isDarkMode(context);
    final Map<int, String> monthMap = {
      1: 'January',
      2: 'February',
      3: 'March',
      4: 'April',
      5: 'May',
      6: 'June',
      7: 'July',
      8: 'August',
      9: 'September',
      10: 'October',
      11: 'November',
      12: 'December',
    };
    DateTime currentDate = DateTime.now();
    String currentMonth = monthMap[currentDate.month]!;
    String formattedDate = DateFormat('dd MMM yyyy').format(currentDate);
    final Employee? currentEmployee = context.select((EmployeeBloc bloc) {
      return bloc.currentEmployee;
    });
    return Column(
      children: [
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: isDarkMode
                ? EchnoColors.attendanceCarddark
                : EchnoColors.attendanceCardlight,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: EchnoSize.xs,
                ),
                Text(
                  "Attendance Report",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  height: EchnoSize.xs,
                ),
                Text(formattedDate),
              ],
            ),
          ),
        ),
        AttendanceCardMonthly(
            employeeId: currentEmployee!.employeeId,
            attendanceMonth: currentMonth,
            attYear: currentDate.year.toString()),
      ],
    );
  }
}
