import 'package:echno_attendance/site_module/models/site_model.dart';

abstract class SiteState {
  const SiteState();
}

class SiteManagementDashboardState extends SiteState {
  const SiteManagementDashboardState();
}

class SiteHomeState extends SiteState {
  final SiteOffice siteOffice;
  const SiteHomeState({required this.siteOffice});
}

class SiteCreateState extends SiteState {
  const SiteCreateState();
}

class SiteAttendanceReportState extends SiteState {
  final SiteOffice siteOffice;
  const SiteAttendanceReportState({required this.siteOffice});
}

class SiteLeaveRegisterState extends SiteState {
  final SiteOffice siteOffice;
  const SiteLeaveRegisterState({required this.siteOffice});
}

class SiteTaskManagementState extends SiteState {
  final SiteOffice siteOffice;
  const SiteTaskManagementState({required this.siteOffice});
}

class SiteMemberManagementState extends SiteState {
  final SiteOffice siteOffice;
  const SiteMemberManagementState({required this.siteOffice});
}
