import 'package:echno_attendance/site_module/models/site_model.dart';

abstract class TaskState {
  const TaskState();
}

class TaskHomeState extends TaskState {
  final SiteOffice siteOffice;
  const TaskHomeState({required this.siteOffice});
}
