import 'package:echno_attendance/auth/services/auth_services/auth_service.dart';
import 'package:echno_attendance/constants/colors_string.dart';
import 'package:echno_attendance/constants/leave_module_strings.dart';
import 'package:echno_attendance/leave_module/models/leave_model.dart';
import 'package:echno_attendance/leave_module/services/leave_services.dart';
import 'package:echno_attendance/leave_module/utilities/leave_cancel_dialog.dart';
import 'package:echno_attendance/leave_module/utilities/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LeaveStatusScreen extends StatefulWidget {
  const LeaveStatusScreen({super.key});
  static const EdgeInsetsGeometry containerPadding =
      EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0);

  @override
  State<LeaveStatusScreen> createState() => LeaveStatusScreenState();
}

class LeaveStatusScreenState extends State<LeaveStatusScreen> {
  final currentUserId = AuthService.firebase().currentUser?.uid;
  final _leaveProvider = LeaveService.firestoreLeave();
  get isDarkMode => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: isDarkMode ? echnoLightBlueColor : echnoBlueColor),
        backgroundColor: isDarkMode ? echnoLightBlueColor : echnoBlueColor,
        title: const Text(leaveStatusAppBarTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: LeaveStatusScreen.containerPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  leaveStatusScreenTitle,
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.left,
                ),
                Text(
                  leaveStatusSubtitle,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10.0),
                const Divider(height: 3.0),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Leave>>(
              stream: _leaveProvider.streamLeaveHistory(uid: currentUserId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      children: [
                        const Center(child: LinearProgressIndicator()),
                        const SizedBox(height: 10),
                        Text(
                          leaveStatusLoadingText,
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      leaveStatusNoLeaveData,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  final orderedLeaves = snapshot.data!.toList()
                    ..sort((a, b) => b.appliedDate.compareTo(a.appliedDate));
                  return ListView.builder(
                    itemCount: orderedLeaves.length,
                    itemExtent: 180.0,
                    itemBuilder: (context, index) {
                      final leave = orderedLeaves[index];
                      return leaveRow(leave);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget leaveRow(Leave leave) {
    final String formatedFromDate = formatDate(leave.fromDate);
    final String formatedToDate = formatDate(leave.toDate);
    final String appliedDate = formatDate(leave.appliedDate);
    final thumbnail = Container(
      alignment: const FractionalOffset(0.0, 0.5),
      margin: const EdgeInsets.only(left: 15.0),
      child: Hero(
        tag: leave.id,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: echnoDarkColor,
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

    final leaveCard = Container(
      height: 200,
      margin: const EdgeInsets.only(left: 45.0, right: 20.0),
      decoration: BoxDecoration(
        color: isDarkMode ? echnoLightBlueColor : echnoBlueColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 16.0, left: 72.0),
        constraints: const BoxConstraints.expand(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              getLeaveTypeName(
                  leave.leaveType), // Assuming leaveType is an enum
              style: const TextStyle(
                color: echnoDarkColor,
                fontFamily: 'TT Chocolates Bold',
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              '$formatedFromDate - $formatedToDate',
              style: const TextStyle(
                color: echnoDarkColor,
                fontFamily: 'TT Chocolates Bold',
                fontWeight: FontWeight.w300,
                fontSize: 15.0,
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
                    color: echnoDarkColor,
                  ),
                ),
                Text(
                  leave.isCancelled
                      ? 'Cancelled'
                      : getLeaveStatusName(leave.leaveStatus),
                  style: const TextStyle(
                    color: echnoDarkColor,
                    fontFamily: 'TT Chocolates Bold',
                    fontWeight: FontWeight.w300,
                    fontSize: 14.0,
                  ),
                ),
                Container(width: 70.0),
                leave.leaveStatus == LeaveStatus.approved ||
                        leave.leaveStatus == LeaveStatus.rejected ||
                        leave.isCancelled
                    ? Container(
                        height: 35,
                      )
                    : GestureDetector(
                        onTap: () async {
                          final shouldCancel = await showCancelDialog(context);
                          if (shouldCancel) {
                            await _leaveProvider.cancelLeave(leaveId: leave.id);
                          }
                        },
                        child: Container(
                          width: 60.0,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: leaveCancelButtonColor,
                          ),
                          child: const Column(
                            children: <Widget>[
                              Icon(
                                Icons.arrow_upward,
                                size: 20.0,
                                color: echnoDarkColor,
                              ),
                              Text(
                                leaveStatusCancelButtonLabel,
                                style: TextStyle(
                                  color: echnoDarkColor,
                                  fontFamily: 'TT Chocolates Bold',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.0,
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
              style: const TextStyle(
                color: echnoDarkColor,
                fontFamily: 'TT Chocolates Bold',
                fontWeight: FontWeight.w600,
                fontSize: 12.0,
                letterSpacing: 0.5,
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
          leaveCard,
          thumbnail,
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day-$month-$year';
  }
}
