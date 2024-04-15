import 'package:echno_attendance/auth/bloc/auth_bloc.dart';
import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/employee/bloc/employee_bloc.dart';
import 'package:echno_attendance/employee/bloc/employee_event.dart';
import 'package:echno_attendance/employee/bloc/employee_state.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/screens/mainapp_attreport.dart';
import 'package:echno_attendance/employee/screens/mainapp_homepage.dart';
import 'package:echno_attendance/employee/screens/profile_screen.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:echno_attendance/utilities/show_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  final int? index;
  const HomePage({super.key, this.index});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Employee currentEmployee;
  late PageController pageController;
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.index ?? 2);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = EchnoHelperFunctions.isDarkMode(context);
    final currentEmployee = context.select((EmployeeBloc bloc) {
      return bloc.currentEmployee;
    });
    return Scaffold(
      // backgroundColor: const Color(0xFFFFE3CA),
      extendBody: true,
      appBar: EchnoAppBar(
        leadingIcon: Icons.menu,
        leadingOnPressed: () {
          context.read<EmployeeBloc>().add(
                const EmployeeProfileEvent(section: 'profile_home_section'),
              );
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              EchnoHelperFunctions.greetEmployeeBasedOnTime(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              currentEmployee.employeeName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
      body: BlocListener<EmployeeBloc, EmployeeState>(
        listener: (context, state) async {
          if (state is EmployeeHomeState) {
            if (state.exception != null) {
              await showErrorDialog(context, state.exception!.toString());
            }
          }
        },
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: const <Widget>[
            MainAttendanceReportScreen(),
            Placeholder(),
            MainHome(),
            Placeholder(),
            ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        indicatorColor:
            isDark ? EchnoColors.selectedNavDark : EchnoColors.selectedNavLight,
        height: 70,
        elevation: 4,
        backgroundColor: isDark ? EchnoColors.secondary : EchnoColors.primary,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          pageController.animateToPage(index,
              duration: const Duration(microseconds: 100),
              curve: Curves.easeIn);
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.calendar_today,
            ),
            label: 'Attendance',
          ),
          NavigationDestination(
            icon: Icon(Icons.check),
            label: 'Check In/Out',
          ),
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.arrow_upward),
            label: 'Request',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
