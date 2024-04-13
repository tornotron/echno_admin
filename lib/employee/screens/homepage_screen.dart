import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/employee/bloc/employee_bloc.dart';
import 'package:echno_attendance/employee/bloc/employee_event.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/screens/mainapp_attreport.dart';
import 'package:echno_attendance/employee/screens/mainapp_homepage.dart';
import 'package:echno_attendance/employee/screens/profile_screen.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
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
      body: PageView(
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
      bottomNavigationBar: BottomNavigationBar(
        elevation: 3,
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDark ? EchnoColors.secondary : EchnoColors.primary,
        selectedItemColor: EchnoColors.buttonPrimary,
        currentIndex: _selectedIndex,
        onTap: (value) {
          pageController.animateToPage(value,
              duration: const Duration(microseconds: 100),
              curve: Curves.easeIn);
          setState(() {
            _selectedIndex = value;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
            ),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Check In/Out',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_upward),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
