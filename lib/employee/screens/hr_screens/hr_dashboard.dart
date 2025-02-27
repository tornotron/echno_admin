import 'package:echno_attendance/auth/services/auth_services/auth_service.dart';
import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/employee/utilities/dashboard_item.dart';
import 'package:echno_attendance/employee/utilities/dashboard_item_list.dart';
import 'package:echno_attendance/employee/widgets/custom_dashboard_tile.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: EchnoAppBar(
        leadingIcon: Icons.menu,
        leadingOnPressed: () {
          AuthService.firebase().logOut();
        },
        title: Text('HR Dashboard',
            style: Theme.of(context).textTheme.headlineSmall),
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
