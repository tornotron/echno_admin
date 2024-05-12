import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/domain/firestore/crud_employee/create_employee.dart';
import 'package:echno_attendance/employee/domain/firestore/crud_employee/delete_employee.dart';
import 'package:echno_attendance/employee/domain/firestore/crud_employee/read_employee.dart';
import 'package:echno_attendance/employee/domain/firestore/crud_employee/update_employee.dart';
import 'package:image_picker/image_picker.dart';

abstract class BasicEmployeeDatabaseHandler implements IReadEmployee {
  Future<Map<String, dynamic>> searchEmployeeByAuthUserId(
      {required String? authUserId});
  Future<Map<String, dynamic>?> searchEmployeeByAuthUserIdBeforeInitialize(
      {required String? authUserId});
  Future<Employee> get currentEmployee;
  Future<Employee?> get currentEmployeeBeforeInialization;
  Future<void> uploadImage(
      {required String imagePath,
      required String employeeId,
      required XFile image});
  Future<void> updateAuthUserIdWithEmployeeId(
      {required String employeeId,
      required String authUserId,
      required String authUserEmail,
      required bool isEmailVerified});
}

abstract class HrDatabaseHandler extends BasicEmployeeDatabaseHandler
    implements ICreateEmployee, IUpdateEmployee, IDeleteEmployee {
  Stream<List<Employee>> getAllEmployees({required String? siteOfficeName});
  Future<List<Employee>> populateMemberList(
      {required List<String> employeeIdList});
  Future<List<Employee>> getEmployeeAutoComplete();
  Future<List<Employee>> getProjectManagerList();
  Future<List<Employee>> getSiteManagerList();
  Future<List<Employee>> getSiteSupervisorList();
  Future<List<Employee>> getSiteEngineerList();
  Future<List<Employee>> getTechnicalCoordinatorList();
}
