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
  const EmployeeProfileState();
}

class HrHomeState extends EmployeeState {
  const HrHomeState();
}

class EmployeeLeavesState extends EmployeeState {
  const EmployeeLeavesState();
}
