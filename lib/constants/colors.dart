import 'package:flutter/material.dart';

class EchnoColors {
  // App theme colors
  static const Color primary = Color.fromARGB(255, 255, 255, 255);
  static const Color primaryLight = Color(0xFFF6F5F7);
  static const Color secondary = Color(0xFF6C757D);
  static const Color secondaryDark = Color.fromARGB(255, 74, 78, 82);
  static const Color accent = Color(0xFFB0C7FF);

  // Attendance Colors
  static const Color attendanceCard = Colors.indigoAccent;

  // Text colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textWhite = Colors.white;
  static const Color textBlack = Colors.black;

  // Icon colors
  static const Color iconPrimary = Colors.indigoAccent;
  static const Color iconSecondary = Color(0xFF6C757D);

  // Bottom Navigation Bar colors
  static const Color selectedNavDark = Colors.black;
  static const Color selectedNavLight = Colors.indigoAccent;

  // Background colors
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFF3F5FF);

  // Background Container colors
  static const Color lightContainer = Color(0xFF6C757D);
  static Color darkContainer = EchnoColors.white.withOpacity(0.1);
  static const Color lightCard = Color(0xFFFEFDFF);
  static const Color darkCard = Color(0xFF6C757D);

  // Button colors
  static const Color buttonPrimary = Colors.indigoAccent;
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  // Border colors
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  // Error and validation colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // Neutral Shades
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);

  // Box Shadow Colors
  static const Color lightShadow = Color(0x66000000);
  static const Color darkShadow = Color(0x8A000000);

  // Leave status colors
  static const Color leaveApproved = Color(0xFF45A834);
  static const Color leavePending = Color(0xFFFDD835);
  static const Color leaveCancelled = Color(0xFFFB8C00);
  static const Color leaveRejected = Color(0xFFE53935);
  static const Color leaveText = Colors.white;
  static const Color leaveCancelButton = Color(0xFFAB47BC);

  // Task Module Colors
  static const Color taskOnhold = Color(0xFFFB8C00);
  static const Color taskCompleted = Color.fromARGB(255, 39, 160, 45);
  static const Color taskDisposed = Color.fromARGB(255, 192, 13, 0);
  static const Color taskTodo = Color.fromARGB(255, 17, 53, 104);
  static const Color taskInprogress = Color.fromARGB(255, 104, 29, 118);
  static const Color taskBanner = Colors.red;
  static const Color taskText = Color(0xFFf5f5f5);
  static const Color taskIcon = Color(0xFFEEEEEE);
}
