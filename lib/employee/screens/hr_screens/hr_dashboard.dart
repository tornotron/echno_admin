import 'package:echno_attendance/auth/bloc/auth_bloc.dart';
import 'package:echno_attendance/auth/bloc/auth_event.dart';
import 'package:echno_attendance/auth/utilities/alert_dialogue.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/employee/bloc/employee_bloc.dart';
import 'package:echno_attendance/employee/utilities/dashboard_item.dart';
import 'package:echno_attendance/employee/utilities/dashboard_item_list.dart';
import 'package:echno_attendance/employee/widgets/custom_dashboard_tile.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('HR Dashboard',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      drawer: Drawer(
        child: Center(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            children: [
              DrawerHeader(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(currentEmployee.photoUrl ??
                          'https://www.w3schools.com/w3images/avatar2.png'),
                    ),
                    const SizedBox(height: EchnoSize.spaceBtwItems),
                    Text('HR',
                        style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
              ),
              ListTile(
                title: Text('Profile',
                    style: Theme.of(context).textTheme.bodySmall),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: EchnoColors.error),
                ),
                onTap: () async {
                  final authBloc = context.read<AuthBloc>();
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    authBloc.add(const AuthLogOutEvent());
                  }
                },
              ),
            ],
          ),
        ),
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
