import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/services/hr_employee_service.dart';
import 'package:echno_attendance/site_module/bloc/site_event.dart';
import 'package:echno_attendance/site_module/bloc/site_state.dart';
import 'package:echno_attendance/site_module/models/site_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SiteBloc extends Bloc<SiteEvent, SiteState> {
  final HrEmployeeService hrEmployeeService = HrEmployeeService.firestore();
  List<Employee> employees = [];
  List<Employee> projectManagers = [];
  List<Employee> supervisors = [];
  List<Employee> siteEngineers = [];
  List<Employee> technicalCoordinators = [];
  List<Employee> members = [];
  SiteBloc() : super(const SiteManagementDashboardState()) {
    on<SiteManagementDashboardEvent>((event, emit) async {
      employees = await hrEmployeeService.getEmployeeAutoComplete();
      projectManagers = await hrEmployeeService.getProjectManagerList();
      supervisors = await hrEmployeeService.getSiteSupervisorList();
      siteEngineers = await hrEmployeeService.getSiteEngineerList();
      technicalCoordinators =
          await hrEmployeeService.getTechnicalCoordinatorList();
      emit(const SiteManagementDashboardState());
    });
    on<SiteHomeEvent>((event, emit) async {
      final SiteOffice siteOffice = event.siteOffice;
      members = await hrEmployeeService.populateMemberList(
          employeeIdList: siteOffice.membersList);
      emit(SiteHomeState(siteOffice: siteOffice));
    });
    on<SiteCreateEvent>((event, emit) {
      emit(const SiteCreateState());
    });
    on<SiteAttendanceReportEvent>((event, emit) {
      emit(SiteAttendanceReportState(siteOffice: event.siteOffice));
    });
    on<SiteLeaveRegisterEvent>((event, emit) {
      emit(SiteLeaveRegisterState(siteOffice: event.siteOffice));
    });
    on<SiteTaskManagementEvent>((event, emit) {
      emit(SiteTaskManagementState(siteOffice: event.siteOffice));
    });
    on<SiteMemberManagementEvent>((event, emit) {
      emit(SiteMemberManagementState(siteOffice: event.siteOffice));
    });
  }
}
