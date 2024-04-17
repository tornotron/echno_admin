import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/utilities/employee_role.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  const EmployeeCard({
    required this.employee,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = EchnoHelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? EchnoColors.darkCard : EchnoColors.grey,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(EchnoSize.borderRadiusMd),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: isDark ? EchnoColors.darkShadow : EchnoColors.lightShadow,
              blurRadius: 0.5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: employee.photoUrl != null
                ? NetworkImage(employee.photoUrl!)
                : null,
            child: employee.photoUrl == null
                ? const Icon(Icons.account_circle, size: 60)
                : null,
          ),
          title: Text(
            employee.employeeName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getEmloyeeRoleName(employee.employeeRole),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 17.0,
                      fontWeight: FontWeight.normal,
                    ),
              ),
              Text(
                'Employee ID: ${employee.employeeId}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              Text(
                'Email: ${employee.companyEmail}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                    ),
              ),
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
      ),
    );
  }
}
