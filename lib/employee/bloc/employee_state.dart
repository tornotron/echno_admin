import 'dart:io';

import 'package:camera/camera.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class EmployeeState {
  const EmployeeState();
}

class EmployeeNotInitializedState extends EmployeeState {
  const EmployeeNotInitializedState();
}

class EmployeeInitializedState extends EmployeeState {
  const EmployeeInitializedState();
}

class EmployeeHomeState extends EmployeeState {
  const EmployeeHomeState();
}

class EmployeeProfileState extends EmployeeState {
  final bool isUpdating;
  final Employee currentEmployee;
  const EmployeeProfileState({
    required this.isUpdating,
    required this.currentEmployee,
  });
}

class HrHomeState extends EmployeeState {
  const HrHomeState();
}

class EmployeeLeavesState extends EmployeeState {
  const EmployeeLeavesState();
}

class TakePictureState extends EmployeeState {
  final CameraDescription frontCamera;
  const TakePictureState({required this.frontCamera});
}

class DisplayPictureState extends EmployeeState {
  final File imagePath;
  const DisplayPictureState({required this.imagePath});
}

class AttendanceAlreadyMarkedState extends EmployeeState {
  const AttendanceAlreadyMarkedState();
}
