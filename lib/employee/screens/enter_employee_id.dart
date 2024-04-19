import 'package:echno_attendance/employee/widgets/employee_id_form.dart';
import 'package:echno_attendance/constants/image_strings.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/constants/static_text.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'dart:developer' as devtools show log;

class EnterEmployeeIdScreen extends StatefulWidget {
  const EnterEmployeeIdScreen({super.key});

  @override
  State<EnterEmployeeIdScreen> createState() => _EnterEmployeeIdScreenState();
}

class _EnterEmployeeIdScreenState extends State<EnterEmployeeIdScreen> {
  final GlobalKey<FormState> _authEmployeeIdFormKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    final isDark = EchnoHelperFunctions.isDarkMode(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
          body: SingleChildScrollView(
        child: Padding(
          padding: CustomPaddingStyle.defaultPaddingWithoutAppbar,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                EchnoImages.contactHr,
                height: EchnoSize.imageHeaderHeightLg,
              ),
              const SizedBox(height: EchnoSize.spaceBtwSections),
              Text(
                EchnoText.enterEmployeeIdTitle,
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: EchnoSize.spaceBtwItems / 2),
              Text(
                EchnoText.enterEmployeeIdSubtitle,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: EchnoSize.spaceBtwItems),
              // Form Section Widget
              EnterEmployeeIdForm(
                authEmployeeIdFormKey: _authEmployeeIdFormKey,
                controller: _controller,
                isDark: isDark,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
