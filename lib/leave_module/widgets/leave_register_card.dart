import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/leave_module/models/leave_model.dart';
import 'package:echno_attendance/leave_module/screens/leave_approval_screen.dart';
import 'package:echno_attendance/leave_module/utilities/leave_status.dart';
import 'package:echno_attendance/leave_module/utilities/leave_type.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveRegisterCard extends StatelessWidget {
  final Leave leave;
  const LeaveRegisterCard({
    required this.leave,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String startDate = DateFormat('dd-MM-yyyy').format(leave.fromDate);
    final String endDate = DateFormat('dd-MM-yyyy').format(leave.toDate);
    final String appliedDate =
        DateFormat('dd-MM-yyyy').format(leave.appliedDate);
    final isDark = EchnoHelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.only(
        top: 5.0,
        bottom: 5.0,
      ),
      child: Container(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 5.0,
          bottom: 5.0,
        ),
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
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LeaveApprovalScreen(leave: leave),
              ),
            );
          },
          child: ListTile(
            title: Text(
              leave.employeeName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5.0),
                Text(
                  getLeaveTypeName(leave.leaveType),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 17.0,
                        fontWeight: FontWeight.normal,
                      ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  'Duration :  $startDate  --  $endDate',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                const SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Status : ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                          ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.calendar_today,
                        size: 14.0,
                      ),
                    ),
                    Text(
                      leave.isCancelled == false
                          ? getLeaveStatusName(leave.leaveStatus)
                          : 'Cancelled',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 7.0),
                Text(
                  "'Applied On:  $appliedDate",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
