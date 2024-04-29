import 'package:echno_attendance/site_module/models/site_model.dart';

abstract class SiteEvent {
  const SiteEvent();
}

class SiteManagementDashboardEvent extends SiteEvent {
  const SiteManagementDashboardEvent();
}

class SiteHomeEvent extends SiteEvent {
  final SiteOffice siteOffice;
  const SiteHomeEvent({required this.siteOffice});
}

class SiteCreateEvent extends SiteEvent {
  const SiteCreateEvent();
}

class SiteAttendanceReportEvent extends SiteEvent {
  final SiteOffice siteOffice;
  const SiteAttendanceReportEvent({required this.siteOffice});
}

class SiteLeaveRegisterEvent extends SiteEvent {
  final SiteOffice siteOffice;
  const SiteLeaveRegisterEvent({required this.siteOffice});
}

class SiteTaskManagementEvent extends SiteEvent {
  final SiteOffice siteOffice;
  const SiteTaskManagementEvent({required this.siteOffice});
}

class SiteMemberManagementEvent extends SiteEvent {
  final SiteOffice siteOffice;
  const SiteMemberManagementEvent({required this.siteOffice});
}
