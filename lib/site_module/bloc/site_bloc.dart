import 'package:echno_attendance/site_module/bloc/site_event.dart';
import 'package:echno_attendance/site_module/bloc/site_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SiteBloc extends Bloc<SiteEvent, SiteState> {
  SiteBloc() : super(const SiteManagementDashboardState()) {
    on<SiteManagementDashboardEvent>((event, emit) {
      emit(const SiteManagementDashboardState());
    });
    on<SiteHomeEvent>((event, emit) {
      emit(SiteHomeState(siteOffice: event.siteOffice));
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
