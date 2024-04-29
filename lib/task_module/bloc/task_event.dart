import 'package:echno_attendance/site_module/models/site_model.dart';
import 'package:echno_attendance/task_module/models/task_model.dart';

abstract class TaskEvent {
  const TaskEvent();
}

class TaskHomeEvent extends TaskEvent {
  final SiteOffice siteOffice;
  const TaskHomeEvent({required this.siteOffice});
}

class AddTaskEvent extends TaskEvent {
  final SiteOffice siteOffice;
  const AddTaskEvent({required this.siteOffice});
}

class TaskDetailsEvent extends TaskEvent {
  final Task task;
  final SiteOffice siteOffice;
  const TaskDetailsEvent({
    required this.siteOffice,
    required this.task,
  });
}

class UpdateTaskProgressEvent extends TaskEvent {
  final SiteOffice siteOffice;
  final Task task;
  const UpdateTaskProgressEvent({
    required this.siteOffice,
    required this.task,
  });
}
