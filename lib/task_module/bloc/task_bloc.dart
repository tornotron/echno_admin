import 'package:echno_attendance/site_module/models/site_model.dart';
import 'package:echno_attendance/task_module/bloc/task_event.dart';
import 'package:echno_attendance/task_module/bloc/task_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final SiteOffice siteOffice;
  TaskBloc({required this.siteOffice})
      : super(TaskHomeState(siteOffice: siteOffice)) {
    on<TaskHomeEvent>((event, emit) {
      emit(TaskHomeState(siteOffice: event.siteOffice));
    });
    on<AddTaskEvent>((event, emit) {
      emit(AddTaskState(siteOffice: event.siteOffice));
    });
    on<TaskDetailsEvent>((event, emit) {
      emit(TaskDetailsState(
        siteOffice: event.siteOffice,
        task: event.task,
      ));
    });
  }
}
