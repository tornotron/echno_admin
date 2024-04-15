import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/leave_module_strings.dart';
import 'package:echno_attendance/leave_module/models/leave_model.dart';
import 'package:echno_attendance/leave_module/services/leave_services.dart';
import 'package:echno_attendance/leave_module/utilities/leave_cancel_dialog.dart';
import 'package:echno_attendance/leave_module/utilities/leave_status.dart';
import 'package:echno_attendance/leave_module/utilities/leave_type.dart';
import 'package:echno_attendance/leave_module/utilities/ui_helper.dart';
import 'package:echno_attendance/utilities/popups/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget leaveStatusCard(
  Leave leave,
  bool isDark,
  BuildContext context,
) {
  final leaveHandler = LeaveService.firestoreLeave();
  final String formatedFromDate =
      DateFormat('dd-MM-yyyy').format(leave.fromDate);
  final String formatedToDate = DateFormat('dd-MM-yyyy').format(leave.toDate);
  final String appliedDate = DateFormat('dd-MM-yyyy').format(leave.appliedDate);
  final thumbnail = Container(
    alignment: const FractionalOffset(0.0, 0.5),
    margin: const EdgeInsets.only(left: 15.0),
    child: Hero(
      tag: leave.leaveId,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: EchnoColors.white,
          border: Border.all(
            width: 5,
            color: getColor(leave.leaveStatus, leave.isCancelled),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: getIcon(leave.leaveStatus, leave.isCancelled),
        ),
      ),
    ),
  );

  final leaveStatusCard = Container(
    height: 200,
    margin: const EdgeInsets.only(left: 45.0, right: 20.0),
    decoration: BoxDecoration(
      color: isDark ? EchnoColors.darkCard : EchnoColors.lightCard,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: isDark ? EchnoColors.darkShadow : EchnoColors.lightShadow,
          blurRadius: 0.5,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: Container(
      margin: const EdgeInsets.only(top: 16.0, left: 65.0),
      constraints: const BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            getLeaveTypeName(leave.leaveType),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 5.0),
          Text(
            '$formatedFromDate -- $formatedToDate',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                ),
          ),
          const SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(2.0),
                child: Icon(
                  Icons.calendar_today,
                  size: 14.0,
                ),
              ),
              Text(
                leave.isCancelled
                    ? 'Cancelled'
                    : getLeaveStatusName(leave.leaveStatus),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w300,
                    ),
              ),
              const SizedBox(width: 100.0),
              leave.leaveStatus == LeaveStatus.approved ||
                      leave.leaveStatus == LeaveStatus.rejected ||
                      leave.isCancelled
                  ? const SizedBox(height: 50)
                  : GestureDetector(
                      onTap: () async {
                        final shouldCancel = await showCancelDialog(context);
                        if (shouldCancel) {
                          await leaveHandler.cancelLeave(
                              leaveId: leave.leaveId);
                          if (context.mounted) {
                            EchnoSnackBar.successSnackBar(
                                context: context,
                                title: 'Success...',
                                message:
                                    'Your Leave has been cancelled successfully...');
                          }
                        }
                      },
                      child: Container(
                        width: 80.0,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: EchnoColors.leaveCancelButton,
                        ),
                        child: Column(
                          children: <Widget>[
                            const Icon(
                              Icons.arrow_upward,
                              color: EchnoColors.white,
                              size: 20.0,
                            ),
                            Text(
                              leaveStatusCancelButtonLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: EchnoColors.white,
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    )
            ],
          ),
          const SizedBox(height: 5.0),
          Text(
            "$leaveAppliedOnFieldLabel $appliedDate",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
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
        leaveStatusCard,
        thumbnail,
      ],
    ),
  );
}
