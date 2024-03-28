import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/image_strings.dart';
import 'package:echno_attendance/employee/bloc/employee_bloc.dart';
import 'package:echno_attendance/employee/bloc/employee_event.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeProfilePhoto extends StatelessWidget {
  const EmployeeProfilePhoto({
    super.key,
    required this.currentEmployee,
    required this.isDark,
    required this.isUpdating,
  });

  final Employee currentEmployee;
  final bool isDark;
  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    Widget content = ClipRRect(
      borderRadius: BorderRadius.circular(100.00),
      child: currentEmployee.photoUrl != null
          ? Image.network(currentEmployee.photoUrl!, fit: BoxFit.cover)
          : const Image(
              image: AssetImage(EchnoImages.profilePlaceholder),
              fit: BoxFit.cover,
            ),
    );
    if (isUpdating) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Center(
      child: Stack(
        children: [
          Visibility(
            visible: currentEmployee.photoUrl == null,
            child: SizedBox(
              height: 120.0,
              width: 120.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.00),
                child: const Image(
                  image: AssetImage(EchnoImages.profilePlaceholder),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 120.0,
            width: 120.0,
            child: content,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              child: Container(
                height: 30.0,
                width: 30.0,
                decoration: BoxDecoration(
                  color: isDark ? EchnoColors.secondary : EchnoColors.primary,
                  borderRadius: BorderRadius.circular(100.00),
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: isDark ? EchnoColors.black : EchnoColors.white,
                ),
              ),
              onTap: () async {
                context.read<EmployeeBloc>().add(
                      EmployeeUpdatePhotoEvent(
                        employeeId: currentEmployee.employeeId,
                      ),
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}
