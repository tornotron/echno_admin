import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/leave_module/models/leave_model.dart';
import 'package:echno_attendance/leave_module/widgets/leave_approval_form.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/material.dart';

class LeaveApprovalScreen extends StatelessWidget {
  final Leave leave;
  const LeaveApprovalScreen({
    super.key,
    required this.leave,
  });

  @override
  Widget build(context) {
    return Scaffold(
      appBar: EchnoAppBar(
        leadingIcon: Icons.arrow_back_ios_new,
        leadingOnPressed: () {
          Navigator.pop(context);
        },
        title: Text('Leave Sanction',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: CustomPaddingStyle.defaultPaddingWithAppbar,
          child: LeaveApprovalForm(
            leave: leave,
          ),
        ),
      ),
    );
  }
}
