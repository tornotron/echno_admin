import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echno_attendance/logger.dart';
import 'package:logger/logger.dart';

class SiteEmpAdd {
  final String empId;
  final String siteOfficeName;
  SiteEmpAdd({required this.empId, required this.siteOfficeName});
  final logs = logger(SiteEmpAdd, Level.info);
  Future<void> assignment() async {
    try {
      DocumentReference siteRef =
          FirebaseFirestore.instance.collection('site').doc(siteOfficeName);
      siteRef.update({
        'employee-list': FieldValue.arrayUnion([empId])
      }).then((_) {
        logs.i("Item added  to list succesfully");
      }).catchError((error) {
        logs.e("Failed to add item to list");
      });
    } on FirebaseException catch (error) {
      logs.e('Firebase Exception : ${error.message}');
    } catch (e) {
      logs.e('Other Exception : $e');
    }
  }
}
