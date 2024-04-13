import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echno_attendance/logger.dart';
import 'package:logger/logger.dart';

class AttendanceCheck {
  Future<bool> attendanceTodayCheck(String employeeId, String date) async {
    final logs = logger(AttendanceCheck, Level.info);
    try {
      DocumentSnapshot<Map<String, dynamic>> att = await FirebaseFirestore
          .instance
          .collection('attendance')
          .doc(employeeId)
          .collection('attendancedate')
          .doc(date)
          .get();

      Map<String, dynamic>? data = att.data();

      if (data == null) {
        return false;
      }

      if (data.containsKey('employee-name')) {
        return true;
      } else {
        return false;
      }
    } on FirebaseException catch (error) {
      logs.e('Firebase Exception: ${error.message}');
      throw Exception('Firebase Exception: ${error.message}');
    } catch (e) {
      logs.e('Other Exception: $e');
      throw Exception('Other Exception: $e');
    }
  }
}
