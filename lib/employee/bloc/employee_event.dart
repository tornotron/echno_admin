import 'dart:io';

import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class EmployeeEvent {
  const EmployeeEvent();
}

class EmployeeInitializeEvent extends EmployeeEvent {
  const EmployeeInitializeEvent();
}

class EmployeeHomeEvent extends EmployeeEvent {
  const EmployeeHomeEvent();
}

class EmployeeProfileEvent extends EmployeeEvent {
  final String section;
  const EmployeeProfileEvent({
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
  const HrHomeEvent();
}

class MarkAttendanceEvent extends EmployeeEvent {
  final bool isPictureTaken;
  final bool isPictureUploaded;
  final File? imagePath;
  final String? imageUrl;
  const MarkAttendanceEvent({
    this.imagePath,
    this.imageUrl,
    required this.isPictureTaken,
    required this.isPictureUploaded,
  });
}
