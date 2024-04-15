import 'package:bloc/bloc.dart';
import 'package:echno_attendance/attendance/services/attendance_insertservice.dart';
import 'package:echno_attendance/attendance/services/attendance_todaycheck.dart';
import 'package:echno_attendance/attendance/services/location_service.dart';
import 'package:echno_attendance/camera/camera_provider.dart';
import 'package:echno_attendance/employee/bloc/employee_event.dart';
import 'package:echno_attendance/employee/bloc/employee_state.dart';
import 'package:echno_attendance/employee/domain/firestore/database_handler.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/site_module/models/site_model.dart';
import 'package:echno_attendance/site_module/services/site_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final BasicEmployeeDatabaseHandler basicEmployeeDatabaseHandler;
  final SiteService siteService = SiteService.firestore();
  late Employee currentEmployee;
  late List<SiteOffice> siteOffices;
  late bool isAttendanceMarked;
  final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  EmployeeBloc(this.basicEmployeeDatabaseHandler)
      : super(const EmployeeNotInitializedState()) {
    on<EmployeeInitializeEvent>((event, emit) async {
      currentEmployee = await basicEmployeeDatabaseHandler.currentEmployee;
      siteOffices = await siteService.populateSiteOfficeList(
          siteNameList: currentEmployee.sites!);
      isAttendanceMarked = await AttendanceCheck()
          .attendanceTodayCheck(currentEmployee.employeeId, formattedDate);
      emit(const EmployeeInitializedState());
    });
    on<EmployeeHomeEvent>((event, emit) {
      emit(const EmployeeHomeState());
    });
    on<EmployeeProfileEvent>((event, emit) async {
      if (event.section == 'profile_leave_section') {
        emit(const EmployeeLeavesState());
      } else {
        emit(EmployeeProfileState(
            isUpdating: false, currentEmployee: currentEmployee));
      }
    });
    on<EmployeeUpdatePhotoEvent>((event, emit) async {
      emit(EmployeeProfileState(
          isUpdating: true, currentEmployee: currentEmployee));
      final imagePicker = ImagePicker();
      final XFile? image = await imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 70,
          maxHeight: 512.0,
          maxWidth: 512.0);
      if (image != null && event.employeeId.isNotEmpty) {
        await basicEmployeeDatabaseHandler.uploadImage(
            imagePath: 'Profile/', employeeId: event.employeeId, image: image);
      }
      currentEmployee = await basicEmployeeDatabaseHandler.currentEmployee;
      emit(EmployeeProfileState(
          isUpdating: false, currentEmployee: currentEmployee));
    });
    on<HrHomeEvent>((event, emit) {
      emit(const HrHomeState());
    });
    on<MarkAttendanceEvent>((event, emit) async {
      isAttendanceMarked = await AttendanceCheck()
          .attendanceTodayCheck(currentEmployee.employeeId, formattedDate);
      if (currentEmployee.sites == null || currentEmployee.sites!.isEmpty) {
        emit(EmployeeHomeState(
            exception: Exception("No site assigned to this employee")));
      }
      final location = await LocationService().getCurrentLocation();

      if (location['latitude'] == null || location['longitude'] == null) {
        emit(EmployeeHomeState(exception: Exception("Location not found")));
      }

      double currentLatitude = location['latitude']!;
      double currentLongitude = location['longitude']!;

      siteOffices = await siteService.populateSiteOfficeList(
          siteNameList: currentEmployee.sites!);
      SiteOffice? currentSiteOffice;

      bool isEmployeeWithinSite = false;
      for (final siteOffice in siteOffices) {
        isEmployeeWithinSite = await LocationService().isEmployeeWithinSite(
          siteLattitude: siteOffice.siteLatitude,
          siteLongitude: siteOffice.siteLongitude,
          currentLattitude: currentLatitude,
          currentLongitude: currentLongitude,
          siteRadius: siteOffice.siteRadius,
        );
        if (isEmployeeWithinSite) {
          currentSiteOffice = siteOffice;
          break;
        }
      }
      if (!isEmployeeWithinSite) {
        emit(EmployeeHomeState(
            exception: Exception("You are not within any site radius")));
      }
      if (!isAttendanceMarked) {
        final frontCamera = await cameraObjectProvider();
        if (!event.isPictureTaken && !event.isPictureUploaded) {
          emit(TakePictureState(frontCamera: frontCamera));
        } else if (!event.isPictureUploaded) {
          emit(DisplayPictureState(imagePath: event.imagePath!));
        } else {
          await AttendanceInsertionService().attendanceTrigger(
              employeeId: currentEmployee.employeeId,
              employeeName: currentEmployee.employeeName,
              imageUrl: event.imageUrl!,
              siteName: currentSiteOffice!.siteOfficeName);
          isAttendanceMarked = true;
          emit(const AttendanceAlreadyMarkedState());
        }
      } else {
        emit(const AttendanceAlreadyMarkedState());
      }
    });
  }
}
