import 'package:echno_attendance/domain/firestore/manager_abstract.dart';
import 'package:echno_attendance/domain/firestore/userhandling_implementation.dart';

mixin ManagerMixin {
  final FirestoreUserHandleProvider firestoreUserImplementation =
      FirestoreUserServices();

  Future<Map<String, dynamic>> readUser({required String userId}) {
    return firestoreUserImplementation.readUser(userId: userId);
  }
}
