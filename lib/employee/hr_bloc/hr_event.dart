abstract class HrEvent {
  const HrEvent();
}

class HrDashboardEvent extends HrEvent {
  const HrDashboardEvent();
}

class HrNewEmployeeRegisterEvent extends HrEvent {
  const HrNewEmployeeRegisterEvent();
}

class HrAttendanceReportEvent extends HrEvent {
  const HrAttendanceReportEvent();
}

class HrLeaveRegisterEvent extends HrEvent {
  const HrLeaveRegisterEvent();
}

class HrSiteManagementEvent extends HrEvent {
  const HrSiteManagementEvent();
}
