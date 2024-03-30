import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/employee/widgets/hr_widgets/update_details_form_container.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/material.dart';

class UpdateEmployeeDetailsScreen extends StatelessWidget {
  const UpdateEmployeeDetailsScreen({super.key});

  @override
  Widget build(context) {
    final isDark = EchnoHelperFunctions.isDarkMode(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: EchnoAppBar(
          leadingIcon: Icons.arrow_back_ios_new,
          leadingOnPressed: () {
            Navigator.pop(context);
          },
          title: Text(
            'Update Details',
            style: Theme.of(context).textTheme.headlineSmall?.apply(
                  color: isDark ? EchnoColors.black : EchnoColors.white,
                ),
          ),
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: CustomPaddingStyle.defaultPaddingWithAppbar,
            child: UpdateDetailsFormContainer(),
          ),
        ),
      ),
    );
  }
}
