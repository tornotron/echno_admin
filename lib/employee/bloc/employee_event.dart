import 'package:echno_attendance/employee/models/employee.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class EmployeeEvent {
  const EmployeeEvent();
}

class EmployeeInitializeEvent extends EmployeeEvent {
  const EmployeeInitializeEvent();
}

class EmployeeHomeEvent extends EmployeeEvent {
  final Employee currentEmployee;

  const EmployeeHomeEvent({
    required this.currentEmployee,
  });
}

class EmployeeProfileEvent extends EmployeeEvent {
  final Employee currentEmployee;
  final String section;
  const EmployeeProfileEvent({
    required this.currentEmployee,
    required this.section,
  });
}

class EmployeeUpdatePhotoEvent extends EmployeeEvent {
  final String employeeId;
  const EmployeeUpdatePhotoEvent({
    required this.employeeId,
  });
}

class EmployeeAttendanceEvent extends EmployeeEvent {
  final String employeeId;
  final String employeeName;
  const EmployeeAttendanceEvent({
    required this.employeeId,
    required this.employeeName,
  });
}

class HrHomeEvent extends EmployeeEvent {
  final Employee currentEmployee;

  const HrHomeEvent({
    required this.currentEmployee,
  });
}
