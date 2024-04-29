import 'package:echno_attendance/site_module/models/site_model.dart';
import 'package:echno_attendance/task_module/models/task_model.dart';

abstract class TaskState {
  const TaskState();
}

class TaskHomeState extends TaskState {
  final SiteOffice siteOffice;
  const TaskHomeState({required this.siteOffice});
}

class AddTaskState extends TaskState {
  final SiteOffice siteOffice;
  const AddTaskState({required this.siteOffice});
}

class TaskDetailsState extends TaskState {
  final Task task;
  final SiteOffice siteOffice;
  const TaskDetailsState({
    required this.siteOffice,
    required this.task,
  });
}

class UpdateTaskProgressState extends TaskState {
  final SiteOffice siteOffice;
  final Task task;
  const UpdateTaskProgressState({
    required this.siteOffice,
    required this.task,
  });
}
