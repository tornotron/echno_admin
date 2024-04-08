import 'package:bloc/bloc.dart';
import 'package:echno_attendance/employee/bloc/employee_event.dart';
import 'package:echno_attendance/employee/bloc/employee_state.dart';
import 'package:echno_attendance/employee/domain/firestore/database_handler.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:image_picker/image_picker.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final BasicEmployeeDatabaseHandler basicEmployeeDatabaseHandler;
  late Employee currentEmployee;

  EmployeeBloc(this.basicEmployeeDatabaseHandler)
      : super(const EmployeeNotInitializedState()) {
    on<EmployeeInitializeEvent>((event, emit) async {
      currentEmployee = await basicEmployeeDatabaseHandler.currentEmployee;
      emit(const EmployeeInitializedState());
    });
    on<EmployeeHomeEvent>((event, emit) {
      emit(const EmployeeHomeState());
    });
    on<EmployeeProfileEvent>((event, emit) async {
      if (event.section == 'profile_leave_section') {
        emit(const EmployeeLeavesState());
      } else {
        emit(EmployeeProfileState(
            isUpdating: false, currentEmployee: currentEmployee, index: 2));
      }
    });
    on<EmployeeUpdatePhotoEvent>((event, emit) async {
      emit(EmployeeProfileState(
          isUpdating: true, currentEmployee: currentEmployee));
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
      currentEmployee = await basicEmployeeDatabaseHandler.currentEmployee;
      emit(EmployeeProfileState(
          isUpdating: false, currentEmployee: currentEmployee, index: 2));
    });
    on<HrHomeEvent>((event, emit) {
      emit(const HrHomeState());
    });
  }
}
