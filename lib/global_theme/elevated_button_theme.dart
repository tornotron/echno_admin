import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:flutter/material.dart';

class EchnoElevatedButtonTheme {
  EchnoElevatedButtonTheme._();

/* -- Light Theme -- */
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: EchnoColors.light,
      backgroundColor: EchnoColors.buttonPrimary,
      disabledForegroundColor: EchnoColors.darkGrey,
      disabledBackgroundColor: EchnoColors.buttonDisabled,
      side: const BorderSide(color: EchnoColors.buttonPrimary),
      padding: const EdgeInsets.symmetric(vertical: EchnoSize.buttonHeight),
      textStyle: const TextStyle(
          fontSize: 16,
          color: EchnoColors.textWhite,
          fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EchnoSize.buttonRadius)),
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: EchnoColors.light,
      backgroundColor: EchnoColors.buttonSecondary,
      disabledForegroundColor: EchnoColors.darkGrey,
      disabledBackgroundColor: EchnoColors.darkerGrey,
      side: const BorderSide(color: EchnoColors.buttonSecondary),
      padding: const EdgeInsets.symmetric(vertical: EchnoSize.buttonHeight),
      textStyle: const TextStyle(
          fontSize: 16,
          color: EchnoColors.textWhite,
          fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EchnoSize.buttonRadius)),
    ),
  );
}
