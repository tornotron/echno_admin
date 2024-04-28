import 'package:echno_attendance/employee/hr_bloc/hr_state.dart';
import 'package:echno_attendance/employee/hr_bloc/hr_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HrBloc extends Bloc<HrEvent, HrState> {
  HrBloc() : super(const HrDashboardState()) {
    on<HrDashboardEvent>((event, emit) {
      emit(const HrDashboardState());
    });
    on<HrNewEmployeeRegisterEvent>((event, emit) {
      emit(const HrNewEmployeeRegisterState());
    });
    on<HrAttendanceReportEvent>((event, emit) {
      emit(const HrAttendanceReportState());
    });
    on<HrLeaveRegisterEvent>((event, emit) {
      emit(const HrLeaveRegisterState());
    });
    on<HrSiteManagementEvent>((event, emit) {
      emit(const HrSiteManagementState());
    });
  }
}
