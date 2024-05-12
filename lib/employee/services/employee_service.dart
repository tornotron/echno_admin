import 'package:camera/camera.dart';
import 'package:echno_attendance/employee/domain/firestore/database_handler.dart';
import 'package:echno_attendance/employee/domain/firestore/firestore_database_handler.dart';
import 'package:echno_attendance/employee/models/employee.dart';

class EmployeeService implements BasicEmployeeDatabaseHandler {
  final BasicEmployeeDatabaseHandler _handler;
  const EmployeeService(this._handler);

  factory EmployeeService.firestore() {
    return EmployeeService(BasicEmployeeFirestoreDatabaseHandler());
  }

  @override
  Future<Employee> get currentEmployee {
    return _handler.currentEmployee;
  }

  @override
  Future<Employee?> get currentEmployeeBeforeInialization {
    return _handler.currentEmployee;
  }

  @override
  Future<Employee?> readEmployee({required String employeeId}) {
    return _handler.readEmployee(employeeId: employeeId);
  }

  @override
  Future<Map<String, dynamic>> searchEmployeeByAuthUserId(
      {required String? authUserId}) {
    return _handler.searchEmployeeByAuthUserId(authUserId: authUserId);
  }

  @override
  Future<Map<String, dynamic>?> searchEmployeeByAuthUserIdBeforeInitialize(
      {required String? authUserId}) {
    return _handler.searchEmployeeByAuthUserIdBeforeInitialize(
        authUserId: authUserId);
  }

  @override
  Future<void> uploadImage(
      {required String imagePath,
      required String employeeId,
      required XFile image}) {
    return _handler.uploadImage(
      imagePath: imagePath,
      employeeId: employeeId,
      image: image,
    );
  }

  @override
  Future<void> updateAuthUserIdWithEmployeeId(
      {required String employeeId,
      required String authUserId,
      required String authUserEmail,
      required bool isEmailVerified}) {
    return _handler.updateAuthUserIdWithEmployeeId(
      employeeId: employeeId,
      authUserId: authUserId,
      authUserEmail: authUserEmail,
      isEmailVerified: isEmailVerified,
    );
  }
}
