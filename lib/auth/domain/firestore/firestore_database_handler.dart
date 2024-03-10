import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echno_attendance/auth/domain/firestore/database_handler.dart';
import 'package:echno_attendance/auth/models/auth_user.dart';
import 'package:echno_attendance/auth/utilities/auth_exceptions.dart';

class FirestoreDatabaseHandler implements DatabaseHandler {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<Map<String, dynamic>> searchForEmployeeInDatabase(
      {required String employeeId}) async {
    String? name, email, phoneNumber, userRole;
    bool? isActiveUser;
    try {
      CollectionReference employeesCollection =
          FirebaseFirestore.instance.collection('employees');

      DocumentSnapshot employeeDocument =
          await employeesCollection.doc(employeeId).get();

      if (employeeDocument.exists) {
        Map<String, dynamic> employeeData =
            employeeDocument.data() as Map<String, dynamic>;
        name = employeeData['full-name'];
        email = employeeData['email-id'];
        phoneNumber = employeeData['phone'];
        userRole = employeeData['employee-role'];
        isActiveUser = employeeData['employee-status'];
      }
    } on FirebaseException catch (error) {
      switch (error.code) {
        case 'not-found':
          throw NotAnEmployeeException();
        default:
          throw GenericAuthException('Firestore Exception: ${error.message}');
      }
    } catch (e) {
      throw GenericAuthException('Other Exception: $e');
    }
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'userRole': userRole,
      'isActiveUser': isActiveUser,
    };
  }

  @override
  Future<AuthUser?> searchForUserInDatabase(
      {required String authUserId}) async {
    final String email;
    final bool isEmailVerified;
    AuthUser? authUser;

    try {
      CollectionReference userCollection = _firestore.collection('users');

      DocumentSnapshot userDocument =
          await userCollection.doc(authUserId).get();

      if (userDocument.exists) {
        Map<String, dynamic> authUserData =
            userDocument.data() as Map<String, dynamic>;
        email = authUserData['auth-user-email'];
        isEmailVerified = authUserData['is-email-verified'];

        authUser = AuthUser(
          false,
          uid: authUserId,
          email: email,
          isEmailVerified: isEmailVerified,
        );
      }
    } on FirebaseException catch (error) {
      switch (error.code) {
        case 'not-found':
          throw NotAnEmployeeException();
        default:
          throw GenericAuthException('Firestore Exception: ${error.message}');
      }
    } catch (e) {
      throw GenericAuthException('Other Exception: $e');
    }
    return authUser;
  }

  @override
  Future<void> updateAuthUserToDatabase({
    String? employeeId,
    required AuthUser authUser,
  }) async {
    try {
      CollectionReference userCollection = _firestore.collection('users');

      await userCollection.doc(authUser.uid).set({
        'auth-user-id': authUser.uid,
        'auth-user-email': authUser.email,
        'is-email-verified': authUser.isEmailVerified,
      });

      if (employeeId != null) {
        CollectionReference employeesCollection =
            _firestore.collection('employees');
        DocumentSnapshot employeeDocument =
            await employeesCollection.doc(employeeId).get();

        if (employeeDocument.exists) {
          await employeesCollection.doc(employeeId).update({
            'auth-user-id': authUser.uid,
            'auth-user-email': authUser.email,
            'is-email-verified': authUser.isEmailVerified,
          });
        }
      }
    } on FirebaseException catch (error) {
      switch (error.code) {
        case 'not-found':
          throw NotAnEmployeeException();
        default:
          throw GenericAuthException('Firestore Exception: ${error.message}');
      }
    } catch (e) {
      throw GenericAuthException('Other Exception: $e');
    }
  }
}
