import 'package:echno_attendance/attendance/services/attendance_controller.dart';
import 'package:echno_attendance/attendance/domain/firestore/attendance_firestore_handler.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/colors_string.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class AttendanceCardMonthly extends StatelessWidget {
  final String employeeId;
  final String attendanceMonth;
  final String attYear;
  const AttendanceCardMonthly(
      {super.key,
      required this.employeeId,
      required this.attendanceMonth,
      required this.attYear});
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
    return FutureBuilder(
      future: getAttData(
          employeeId: employeeId,
          attendanceMonth: attendanceMonth,
          attYear: attYear),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data!.isEmpty) {
          return Container(
            color: Colors.white,
          );
        } else {
          final dataMap = snapshot.data!;
          final List<Map<String, String>> attendanceMapList =
              dataMap['attendanceData'];
          return Expanded(
            child: ListView.builder(
              itemCount: attendanceMapList.length,
              itemBuilder: (context, index) {
                final Map<String, String> attendanceData =
                    attendanceMapList[index];
                String varemployeeName =
                    attendanceData['employee-name'].toString();
                String varattendanceDate =
                    attendanceData['attendance-date'].toString();
                String varattendanceDay = varattendanceDate.substring(8, 10);

                String varattendanceMonth =
                    attendanceData['attendance-month'].toString();
                String varattendanceTime =
                    attendanceData['attendance-time'].toString();
                ImageProvider employeeImg =
                    NetworkImage(attendanceData['image-url']!);
                varattendanceTime = varattendanceTime.substring(0, 5);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? EchnoColors.attendanceCarddark
                          : EchnoColors.attendanceCardlight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 120,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            constraints: const BoxConstraints(
                              maxHeight: 100,
                              maxWidth: 105,
                            ),
                            width: 95,
                            height: 80,
                            decoration: BoxDecoration(
                              color: echnoBlueLightColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    varattendanceDay,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'TT Chocolates',
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    varattendanceMonth,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'TT Chocolates',
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              varemployeeName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Check-In",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontSize: 13,
                                          ),
                                    ),
                                    Text(
                                      varattendanceTime,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontSize: 12,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Check-out",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontSize: 13,
                                          ),
                                    ),
                                    Text(
                                      "--:--",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontSize: 12,
                                          ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            constraints: const BoxConstraints(
                              maxHeight: 100,
                              maxWidth: 105,
                            ),
                            width: 95,
                            height: 80,
                            decoration: BoxDecoration(
                              color: echnoBlueLightColor,
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: employeeImg,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
