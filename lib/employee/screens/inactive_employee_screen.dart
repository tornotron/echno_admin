import 'package:echno_attendance/auth/bloc/auth_bloc.dart';
import 'package:echno_attendance/auth/bloc/auth_event.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/image_strings.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/constants/static_text.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'dart:developer' as devtools show log;

class InactiveEmployeeScreen extends StatefulWidget {
  const InactiveEmployeeScreen({super.key});

  @override
  State<InactiveEmployeeScreen> createState() => _InactiveEmployeeScreenState();
}

class _InactiveEmployeeScreenState extends State<InactiveEmployeeScreen> {
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
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: CustomPaddingStyle.defaultPaddingWithoutAppbar,
          child: Column(
            children: [
              SvgPicture.asset(
                EchnoImages.inactiveEmp,
                height: EchnoSize.imageHeaderHeightLg,
              ),
              const SizedBox(height: EchnoSize.spaceBtwSections),
              Text(
                EchnoText.inactiveEmployeeTitle,
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: EchnoSize.spaceBtwItems / 2),
              Text(
                EchnoText.inactiveEmployeeSubtitle,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: EchnoSize.spaceBtwItems),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthLogOutEvent(),
                      );
                },
                child: Text(EchnoText.backToLogin,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: isDark
                              ? EchnoColors.buttonSecondary
                              : EchnoColors.buttonPrimary,
                        )),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
