import 'package:flutter/material.dart';

class DashboardItem {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  DashboardItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });
}
