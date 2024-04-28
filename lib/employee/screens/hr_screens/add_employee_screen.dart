import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/constants/static_text.dart';
import 'package:echno_attendance/employee/widgets/hr_widgets/add_employee_form.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/material.dart';

class AddNewEmployee extends StatelessWidget {
  const AddNewEmployee({super.key});

  @override
  Widget build(context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: EchnoAppBar(
          leadingIcon: Icons.arrow_back_ios_new,
          leadingOnPressed: () {
            Navigator.pop(context);
          },
          title: Text('Add Employee',
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: CustomPaddingStyle.defaultPaddingWithAppbar,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(EchnoText.addEmployeeTitle,
                      style: Theme.of(context).textTheme.displaySmall),
                  Text(
                    EchnoText.addEmployeeSubtitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: EchnoSize.spaceBtwSections),
                  const AddEmployeeForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
