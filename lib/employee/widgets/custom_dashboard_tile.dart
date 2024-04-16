import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/employee/utilities/dashboard_item.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CustomDashboardTile extends StatelessWidget {
  final DashboardItem item;

  const CustomDashboardTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = EchnoHelperFunctions.isDarkMode(context);
    return InkWell(
      onTap: item.onTap,
      child: Card(
        color: isDark ? EchnoColors.gridDark : EchnoColors.gridLight,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                size: 48.0,
              ),
              const SizedBox(height: 8.0),
              Text(
                item.text,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
