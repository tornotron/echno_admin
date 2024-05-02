import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/services/hr_employee_service.dart';
import 'package:echno_attendance/site_module/models/site_model.dart';
import 'package:echno_attendance/task_module/bloc/task_event.dart';
import 'package:echno_attendance/task_module/bloc/task_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final SiteOffice siteOffice;
  late List<Employee> members = [];
  TaskBloc({required this.siteOffice})
      : super(TaskHomeState(siteOffice: siteOffice)) {
    on<TaskHomeEvent>((event, emit) {
      emit(TaskHomeState(siteOffice: event.siteOffice));
    });
    on<AddTaskEvent>((event, emit) async {
      members = await HrEmployeeService.firestore()
          .populateMemberList(employeeIdList: siteOffice.membersList);
      emit(AddTaskState(siteOffice: event.siteOffice));
    });
    on<TaskDetailsEvent>((event, emit) {
      emit(TaskDetailsState(
        siteOffice: event.siteOffice,
        task: event.task,
      ));
    });
    on<UpdateTaskProgressEvent>((event, emit) {
      emit(UpdateTaskProgressState(
        siteOffice: event.siteOffice,
        task: event.task,
      ));
    });
  }
}
