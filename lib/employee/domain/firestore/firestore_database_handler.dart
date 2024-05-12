import 'dart:io';

import 'package:echno_attendance/auth/services/auth_services/auth_service.dart';
import 'package:echno_attendance/employee/domain/firestore/database_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/utilities/employee_role.dart';
import 'package:echno_attendance/logger.dart';
import 'package:echno_attendance/utilities/exceptions/firebase_exceptions.dart';
import 'package:echno_attendance/utilities/exceptions/platform_exceptions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class BasicEmployeeFirestoreDatabaseHandler
    implements BasicEmployeeDatabaseHandler {
  final logs = logger(BasicEmployeeFirestoreDatabaseHandler, Level.info);

  @override
  Future<Employee?> readEmployee({
    required String employeeId,
  }) async {
    String employeeName;
    String companyEmail;
    String phoneNumber;
    bool employeeStatus;
    EmployeeRole employeeRole;
    try {
      CollectionReference employeesCollection =
          FirebaseFirestore.instance.collection('employees');

      DocumentSnapshot employeeDocument =
          await employeesCollection.doc(employeeId).get();

      if (employeeDocument.exists) {
        Map<String, dynamic> employeeData =
            employeeDocument.data() as Map<String, dynamic>;

        employeeName = employeeData['employee-name'];
        companyEmail = employeeData['company-email'];
        phoneNumber = employeeData['phone-number'];
        employeeRole = getEmployeeRole(employeeData['employee-role']);
        employeeStatus = employeeData['employee-status'];

        Employee employee = Employee(
          employeeId: employeeId,
          employeeName: employeeName,
          companyEmail: companyEmail,
          phoneNumber: phoneNumber,
          employeeStatus: employeeStatus,
          employeeRole: employeeRole,
        );
        return employee;
      } else {
        logs.i("employee doesn't exist");
      }
    } on FirebaseException catch (error) {
      logs.e('Firebase Exception: ${error.message}');
    } catch (e) {
      logs.e('Other Exception: $e');
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>> searchEmployeeByAuthUserId(
      {required String? authUserId}) async {
    try {
      // Search user with reference to the uid in firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('employees')
          .where('auth-user-id', isEqualTo: authUserId)
          .get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document
        Map<String, dynamic> employeeData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        logs.i('Employee found');
        return employeeData;
      } else {
        logs.i('Employee not found');
        throw Exception('Employee Not Added to Employee Collection');
      }
    } catch (e) {
      logs.e('Error searching for employee: $e');
      throw Exception('Error searching for employee: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> searchEmployeeByAuthUserIdBeforeInitialize(
      {required String? authUserId}) async {
    try {
      // Search user with reference to the uid in firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('employees')
          .where('auth-user-id', isEqualTo: authUserId)
          .get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document
        Map<String, dynamic> employeeData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        logs.i('Employee found');
        return employeeData;
      } else {
        logs.i('Employee Not Added to Employee Collection by Admin');
        return null;
      }
    } catch (e) {
      logs.e('Error searching for employee: $e');
      throw Exception('Error searching for employee: $e');
    }
  }

  @override
  Future<Employee> get currentEmployee async {
    final user = AuthService.firebase().currentUser!;
    Employee employee = await Employee.fromFirebaseUser(user);
    return employee;
  }

  @override
  Future<Employee?> get currentEmployeeBeforeInialization async {
    final user = AuthService.firebase().currentUser!;
    Employee? employee = await Employee.fromFirebaseUserBeforeInitialize(user);
    return employee;
  }

  @override
  Future<void> uploadImage({
    required String imagePath,
    required String employeeId,
    required XFile image,
  }) async {
    try {
      final reference =
          FirebaseStorage.instance.ref(imagePath).child(employeeId);
      await reference.putFile(File(image.path));
      final imageUrl = await reference.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(employeeId)
          .update({'photo-url': imageUrl});
    } catch (e) {
      logs.e('Error uploading image: $e');
      throw Exception('Error uploading image: $e');
    }
  }

  @override
  Future<void> updateAuthUserIdWithEmployeeId(
      {required String employeeId,
      required String authUserId,
      required String authUserEmail,
      required bool isEmailVerified}) async {
    try {
      CollectionReference employeesCollection =
          FirebaseFirestore.instance.collection('employees');

      DocumentSnapshot employeeDocument =
          await employeesCollection.doc(employeeId).get();
      if (employeeDocument.exists) {
        await employeesCollection.doc(employeeId).update({
          'auth-user-id': authUserId,
          'auth-user-email': authUserEmail,
          'is-email-verified': isEmailVerified,
        });
        logs.i('Employee found');
      } else {
        logs.i('Employee not found');
        throw Exception('Employee Not Added to Employee Collection');
      }
    } on FirebaseException catch (error) {
      logs.e('Firebase Exception: ${error.message}');
    } catch (e) {
      logs.e('Other Exception: $e');
      throw Exception('Error updating auth user id with employee id: $e');
    }
  }
}

class HrFirestoreDatabaseHandler extends BasicEmployeeFirestoreDatabaseHandler
    implements HrDatabaseHandler {
  @override
  Future<Employee?> createEmployee(
      {required String employeeId,
      required String employeeName,
      required String companyEmail,
      required String phoneNumber,
      required EmployeeRole employeeRole,
      required bool employeeStatus}) async {
    try {
      CollectionReference userCollection =
          FirebaseFirestore.instance.collection('employees');

      DocumentSnapshot useridCheck = await userCollection.doc(employeeId).get();

      if (!useridCheck.exists) {
        await FirebaseFirestore.instance
            .collection('employees')
            .doc(employeeId)
            .set({
          'employee-id': employeeId,
          'employee-name': employeeName,
          'company-email': companyEmail,
          'phone-number': phoneNumber,
          'employee-role': employeeRole.toString().split('.').last,
          'employee-status': employeeStatus,
        });
        Employee employee = Employee(
          employeeId: employeeId,
          employeeName: employeeName,
          companyEmail: companyEmail,
          phoneNumber: phoneNumber,
          employeeStatus: employeeStatus,
          employeeRole: employeeRole,
        );
        return employee;
      } else {
        logs.i('user already exits');
      }
    } on FirebaseException catch (error) {
      logs.e('Firebase Exception: ${error.message}');
    } catch (e) {
      logs.e('Other Exception: $e');
    }
    return null;
  }

  @override
  Future<Employee?> updateEmployee({
    required String? employeeId,
    String? employeeName,
    String? companyEmail,
    String? phoneNumber,
    EmployeeRole? employeeRole,
    bool? employeeStatus,
  }) async {
    try {
      final employeeDocument =
          FirebaseFirestore.instance.collection('employees').doc(employeeId);
      final employeeDataSnapshot = await employeeDocument.get();

      final Map<String, dynamic> oldEmployeeData =
          employeeDataSnapshot.data() as Map<String, dynamic>;

      final newEmployeeData = <String, dynamic>{};

      if (employeeName != null) {
        newEmployeeData['employee-name'] = employeeName;
      }

      if (companyEmail != null) {
        newEmployeeData['company-email'] = companyEmail;
      }

      if (phoneNumber != null) {
        newEmployeeData['phone-number'] = phoneNumber;
      }

      if (employeeRole != null) {
        newEmployeeData['employee-role'] =
            employeeRole.toString().split('.').last;
      }

      if (employeeStatus != null) {
        newEmployeeData['employee-status'] = employeeStatus;
      }

      await employeeDocument.update(newEmployeeData);

      Employee employee = Employee(
        employeeId: employeeId ?? oldEmployeeData['employee-id'],
        employeeName: oldEmployeeData['employee-name'],
        companyEmail: oldEmployeeData['company-email'],
        phoneNumber: oldEmployeeData['phone-number'],
        employeeStatus: oldEmployeeData['employee-status'],
        employeeRole: getEmployeeRole(oldEmployeeData['employee-role']),
      );
      return employee;
    } on FirebaseException catch (error) {
      logs.e('Firebase Exception: ${error.message}');
    } catch (e) {
      logs.e('Other Exception: $e');
    }
    return null;
  }

  @override
  Future deleteEmployee({required String employeeId}) async {
    try {
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(employeeId)
          .delete();
    } on FirebaseException catch (error) {
      logs.e('Firebase Exception: ${error.message}');
    } catch (e) {
      logs.e('Other Exception: $e');
    }
  }

  @override
  Stream<List<Employee>> getAllEmployees({required String? siteOfficeName}) {
    final String? siteOffice = siteOfficeName;
    try {
      if (siteOffice != null) {
        return FirebaseFirestore.instance
            .collection('employees')
            .where('site-office', isEqualTo: siteOffice)
            .snapshots()
            .map((QuerySnapshot<Map<String, dynamic>> snapshot) => snapshot.docs
                .map((doc) => Employee.fromQueryDocumentSnapshot(doc))
                .toList());
      } else {
        return FirebaseFirestore.instance
            .collection('employees')
            .snapshots()
            .map((QuerySnapshot<Map<String, dynamic>> snapshot) => snapshot.docs
                .map((doc) => Employee.fromQueryDocumentSnapshot(doc))
                .toList());
      }
    } catch (e) {
      logs.e('Error getting all employees: $e');
      throw Exception('Error getting all employees: $e');
    }
  }

  @override
  Future<List<Employee>> populateMemberList(
      {required List<String> employeeIdList}) async {
    try {
      final List<Employee> employeeList = [];
      for (String employeeId in employeeIdList) {
        final DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('employees')
            .doc(employeeId)
            .get();
        if (doc.exists) {
          employeeList.add(Employee.fromDocumentSnapshot(doc));
        }
      }
      return employeeList;
    } on FirebaseException catch (e) {
      throw EchnoFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw EchnoPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong! Please try again.';
    }
  }

  @override
  Future<List<Employee>> getEmployeeAutoComplete() async {
    try {
      QuerySnapshot employeeList =
          await FirebaseFirestore.instance.collection('employees').get();
      return employeeList.docs
          .map((doc) => Employee.fromQueryDocumentSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw EchnoFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw EchnoPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong! Please try again.';
    }
  }

  @override
  Future<List<Employee>> getProjectManagerList() async {
    try {
      QuerySnapshot pmList = await FirebaseFirestore.instance
          .collection('employees')
          .where('employee-role', isEqualTo: 'pm')
          .get();
      return pmList.docs
          .map((doc) => Employee.fromQueryDocumentSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw EchnoFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw EchnoPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong! Please try again.';
    }
  }

  @override
  Future<List<Employee>> getSiteEngineerList() async {
    try {
      QuerySnapshot seList = await FirebaseFirestore.instance
          .collection('employees')
          .where('employee-role', isEqualTo: 'se')
          .get();
      return seList.docs
          .map((doc) => Employee.fromQueryDocumentSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw EchnoFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw EchnoPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong! Please try again.';
    }
  }

  @override
  Future<List<Employee>> getSiteManagerList() async {
    try {
      QuerySnapshot smList = await FirebaseFirestore.instance
          .collection('employees')
          .where('employee-role', isEqualTo: 'sm')
          .get();
      return smList.docs
          .map((doc) => Employee.fromQueryDocumentSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw EchnoFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw EchnoPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong! Please try again.';
    }
  }

  @override
  Future<List<Employee>> getSiteSupervisorList() async {
    try {
      QuerySnapshot spList = await FirebaseFirestore.instance
          .collection('employees')
          .where('employee-role', isEqualTo: 'sp')
          .get();
      return spList.docs
          .map((doc) => Employee.fromQueryDocumentSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw EchnoFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw EchnoPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong! Please try again.';
    }
  }

  @override
  Future<List<Employee>> getTechnicalCoordinatorList() async {
    try {
      QuerySnapshot tcList = await FirebaseFirestore.instance
          .collection('employees')
          .where('employee-role', isEqualTo: 'tc')
          .get();
      return tcList.docs
          .map((doc) => Employee.fromQueryDocumentSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw EchnoFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw EchnoPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong! Please try again.';
    }
  }
}
