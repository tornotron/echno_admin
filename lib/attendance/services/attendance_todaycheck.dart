import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echno_attendance/logger.dart';
import 'package:logger/logger.dart';

class AttendanceCheck {
  Future<bool> attendanceTodayCheck(String employeeId, String date) async {
    final logs = logger(AttendanceCheck, Level.info);
    try {
      var attRef = FirebaseFirestore.instance
          .collection('attendance')
          .doc(employeeId)
          .collection('attendancedate')
          .doc(date)
          .get()
          .then((value) {
        if (value.exists) {
          return true;
        } else {
          return false;
        }
      });
      return attRef;
    } on FirebaseException catch (error) {
      logs.e('Firebase Exception: ${error.message}');
      throw Exception('Firebase Exception: ${error.message}');
    } catch (e) {
      logs.e('Other Exception: $e');
      throw Exception('Other Exception: $e');
    }
  }
}
