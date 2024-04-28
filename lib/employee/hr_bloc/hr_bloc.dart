import 'package:echno_attendance/employee/hr_bloc/hr_state.dart';
import 'package:echno_attendance/employee/hr_bloc/hr_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HrBloc extends Bloc<HrEvent, HrState> {
  HrBloc() : super(const HrDashboardState()) {
    on<HrEvent>((event, emit) {});
  }
}
