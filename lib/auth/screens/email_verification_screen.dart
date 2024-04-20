import 'dart:async';

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
import 'dart:developer' as devtools show log;

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool _isButtonEnabled = false;
  late Timer _timer;
  int _countdown = 120; // 2 minutes

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown -= 1;
        if (_countdown == 0) {
          // Cancel the timer when the countdown reaches 0
          _timer.cancel();
          // Enable the button when the timer reaches 0
          _isButtonEnabled = true;
        }
      });
    });
  }

  void _resendVerificationEmail() {
    setState(() {
      _isButtonEnabled = false;
      _countdown = 180; // Reset countdown
    });
    // Start the timer again
    _startTimer();
    // Resend the verification email
    context.read<AuthBloc>().add(const AuthVerifyEmailEvent());
    devtools.log('Resending Verification Mail...!');
  }

  String _formatTimer(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel(); // Dispose the timer to avoid memory leaks
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
                EchnoImages.emailVerification,
                height: EchnoSize.imageHeaderHeightLg,
              ),
              const SizedBox(height: EchnoSize.spaceBtwSections),
              Text(
                EchnoText.emailVerificationTitle,
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: EchnoSize.spaceBtwItems / 2),
              Text(
                EchnoText.emailVerificationSubtitle,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: EchnoSize.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isButtonEnabled ? _resendVerificationEmail : null,
                  child: Text(
                    _isButtonEnabled
                        ? EchnoText.emailVerificationButton
                        : 'Resend in ${_formatTimer(_countdown)}',
                  ),
                ),
              ),
              const SizedBox(height: EchnoSize.spaceBtwItems),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthLogOutEvent(),
                      );
                },
                child: Text(
                  EchnoText.backToLogin,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isDark
                            ? EchnoColors.buttonSecondary
                            : EchnoColors.buttonPrimary,
                      ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
