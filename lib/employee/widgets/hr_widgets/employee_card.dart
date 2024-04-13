import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/utilities/employee_role.dart';
import 'package:flutter/material.dart';

Widget employeeCard(
  Employee employee,
  bool isDarkMode,
  BuildContext context,
) {
  final leaveRegisterCard = Container(
    height: 170.0,
    margin: const EdgeInsets.only(left: 16.0, right: 16.0),
    decoration: BoxDecoration(
      color: isDarkMode
          ? EchnoColors.black.withOpacity(0.9)
          : EchnoColors.lightCard,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(EchnoSize.borderRadiusMd),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: isDarkMode ? EchnoColors.darkShadow : EchnoColors.lightShadow,
          blurRadius: 0.5,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: Container(
      margin: const EdgeInsets.only(top: 16.0, left: 40.0),
      constraints: const BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            employee.employeeName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 5.0),
          Text(
            getEmloyeeRoleName(employee.employeeRole),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 17.0,
                  fontWeight: FontWeight.normal,
                ),
          ),
          const SizedBox(height: 5.0),
          Text(
            'Employee ID: ${employee.employeeId}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                ),
          ),
          const SizedBox(height: 5.0),
          Text(
            'Email: ${employee.companyEmail}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                ),
          ),
          const SizedBox(height: 5.0),
          Text(
            'Phone: ${employee.phoneNumber}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      ),
    ),
  );

  return Container(
    margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
    child: Stack(
      children: <Widget>[
        leaveRegisterCard,
      ],
    ),
  );
}
