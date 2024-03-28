import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/leave_module/widgets/leave_application_form.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class LeaveApplicationScreen extends StatefulWidget {
  const LeaveApplicationScreen({super.key});
  static const EdgeInsetsGeometry containerPadding =
      EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0);

  @override
  State<LeaveApplicationScreen> createState() => _LeaveApplicationScreenState();
}

class _LeaveApplicationScreenState extends State<LeaveApplicationScreen> {
  @override
  Widget build(context) {
    final isDark = EchnoHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: EchnoAppBar(
        leadingIcon: Icons.arrow_back_ios_new,
        leadingOnPressed: () {
          Navigator.pop(context);
        },
        title: Text(
          'Leave Application',
          style: Theme.of(context).textTheme.headlineSmall?.apply(
                color: isDark ? EchnoColors.black : EchnoColors.white,
              ),
        ),
      ),
      body: const SingleChildScrollView(
        child: LeaveApplicationForm(),
      ),
    );
  }
}
