import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/constants/static_text.dart';
import 'package:echno_attendance/employee/widgets/hr_widgets/employee_register_stream.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/material.dart';

class EmployeeRegisterScreen extends StatefulWidget {
  const EmployeeRegisterScreen({super.key});

  @override
  State<EmployeeRegisterScreen> createState() => _EmployeeRegisterScreenState();
}

class _EmployeeRegisterScreenState extends State<EmployeeRegisterScreen> {
  TextEditingController searchController = TextEditingController();

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
          title: Text('Employee Register',
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        body: Padding(
          padding: CustomPaddingStyle.defaultPaddingWithAppbar,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                EchnoText.employeeRegisterTitle,
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.left,
              ),
              Text(
                EchnoText.employeeRegisterSubtitle,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: EchnoSize.spaceBtwSections),
              TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      (EchnoSize.borderRadiusLg),
                    ),
                  ),
                  labelText: 'Filter',
                  hintText: 'Start Typing...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        searchController.clear();
                      });
                    },
                  ),
                ),
                onChanged: (value) {
                  // Trigger search when the user types
                  setState(() {});
                },
              ),
              const SizedBox(height: EchnoSize.spaceBtwItems),
              const Divider(height: EchnoSize.dividerHeight),
              employeeRegisterStreamBuilder(
                  context: context,
                  searchController: searchController,
                  isDarkMode: isDark)
            ],
          ),
        ),
      ),
    );
  }
}
