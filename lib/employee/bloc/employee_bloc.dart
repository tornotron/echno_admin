import 'package:bloc/bloc.dart';
import 'package:echno_attendance/employee/bloc/employee_event.dart';
import 'package:echno_attendance/employee/bloc/employee_state.dart';
import 'package:echno_attendance/employee/domain/firestore/database_handler.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:image_picker/image_picker.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final BasicEmployeeDatabaseHandler basicEmployeeDatabaseHandler;
  late final Employee _currentEmployee;

  EmployeeBloc(this.basicEmployeeDatabaseHandler)
      : super(const EmployeeNotInitializedState()) {
    on<EmployeeInitializeEvent>((event, emit) async {
      final Employee employee =
          await basicEmployeeDatabaseHandler.currentEmployee;
      _currentEmployee = employee;
      emit(EmployeeInitializedState(currentEmployee: _currentEmployee));
    });
    on<EmployeeHomeEvent>((event, emit) {
      emit(EmployeeHomeState(currentEmployee: _currentEmployee));
    });
    on<EmployeeProfileEvent>((event, emit) async {
      if (event.section == 'profile_leave_section') {
        emit(EmployeeLeavesState(currentEmployee: _currentEmployee));
      } else {
        emit(EmployeeProfileState(currentEmployee: _currentEmployee));
      }
    });
    on<EmployeeUpdatePhotoEvent>((event, emit) async {
      final imagePicker = ImagePicker();
      final XFile? image = await imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 70,
          maxHeight: 512.0,
          maxWidth: 512.0);
      if (image != null && event.employeeId.isNotEmpty) {
        await basicEmployeeDatabaseHandler.uploadImage(
            imagePath: 'Profile/', employeeId: event.employeeId, image: image);
      }
      emit(state);
    });
    on<HrHomeEvent>((event, emit) {
      emit(HrHomeState(currentEmployee: _currentEmployee));
    });
  }
}
