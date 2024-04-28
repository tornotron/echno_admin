import 'package:echno_attendance/employee/bloc/employee_bloc.dart';
import 'package:echno_attendance/employee/utilities/dashboard_item.dart';
import 'package:echno_attendance/employee/utilities/dashboard_item_list.dart';
import 'package:echno_attendance/employee/widgets/custom_dashboard_tile.dart';
import 'package:echno_attendance/employee/widgets/hr_widgets/hr_app_drawer.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HRDashboardScreen extends StatefulWidget {
  const HRDashboardScreen({super.key});

  @override
  State<HRDashboardScreen> createState() => _HRDashboardScreenState();
}

class _HRDashboardScreenState extends State<HRDashboardScreen> {
  late List<DashboardItem> gridData;

  @override
  void initState() {
    super.initState();
    gridData = DashboardItemList.getHrDashboardItems(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final currentEmployee = context.select((EmployeeBloc bloc) {
      return bloc.currentEmployee;
    });
    final isDark = EchnoHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('HR Dashboard',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      drawer: HrAppDrawer(
        currentEmployee: currentEmployee,
        isDark: isDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: gridData.length,
          itemBuilder: (context, index) {
            return CustomDashboardTile(item: gridData[index]);
          },
        ),
      ),
    );
  }
}
