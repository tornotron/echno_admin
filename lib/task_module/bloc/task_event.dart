import 'package:echno_attendance/site_module/models/site_model.dart';

abstract class TaskEvent {
  const TaskEvent();
}

class TaskHomeEvent extends TaskEvent {
  final SiteOffice siteOffice;
  const TaskHomeEvent({required this.siteOffice});
}
