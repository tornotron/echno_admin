import 'package:echno_attendance/attendance/services/attendance_interface.dart';
import 'package:echno_attendance/attendance/domain/firestore/attendance_firestore_handler.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/colors_string.dart';
import 'package:flutter/material.dart';

class AttendanceCardDaily extends StatefulWidget {
  final String siteName;
  final String date;
  const AttendanceCardDaily(
      {super.key, required this.siteName, required this.date});
  @override
  State<AttendanceCardDaily> createState() => _AttendanceCardDailyState();
}

class _AttendanceCardDailyState extends State<AttendanceCardDaily> {
  AttendanceRepositoryInterface attendanceProvider =
      AttendanceFirestoreRepository();
  Future<Map<String, dynamic>> getAttData(
      {required String siteName, required String date}) async {
    final attendanceData = await attendanceProvider.fetchFromDatabaseDaily(
        siteName: siteName, date: date);

    if (attendanceData.isEmpty) {
      return {};
    }

    return {
      'attendanceData': attendanceData,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: getAttData(siteName: widget.siteName, date: widget.date),
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
            return ListView.builder(
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
                      color: EchnoColors.attendanceCard,
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'TT Chocolates',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      "Check-In",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'TT Chocolates',
                                          fontSize: 15),
                                    ),
                                    Text(
                                      varattendanceTime,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'TT Chocolates'),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Column(
                                  children: [
                                    Text(
                                      "Check-out",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'TT Chocolates',
                                          fontSize: 15),
                                    ),
                                    Text(
                                      "--:--",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'TT Chocolates'),
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
            );
          }
        },
      ),
    );
  }
}
