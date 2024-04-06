import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echno_attendance/logger.dart';
import 'package:logger/logger.dart';

class SiteCreate {
  final logs = logger(SiteCreate, Level.info);
  final String siteName;
  SiteCreate({required this.siteName});

  Future<void> creation() async {
    try {
      CollectionReference siteRef =
          FirebaseFirestore.instance.collection('site');
      siteRef.doc(siteName).set({'employee-list': []}, SetOptions(merge: true));
    } on FirebaseException catch (error) {
      logs.e('Firebase Exception : ${error.message}');
    } catch (e) {
      logs.e('Other Exception: $e');
    }
  }
}
