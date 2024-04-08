import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
              style: Theme.of(context).textTheme.bodySmall?.apply(
                    color: isDark ? EchnoColors.black : EchnoColors.white,
                  ),
            ),
            Text(
              currentEmployee.employeeName,
              style: Theme.of(context).textTheme.headlineSmall?.apply(
                    color: isDark ? EchnoColors.black : EchnoColors.white,
                  ),
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
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        index: 2,
        backgroundColor: Colors.transparent,
        color: isDark ? EchnoColors.secondary : EchnoColors.primary,
        items: [
          SizedBox(
            child: Image.asset(
              'assets/icons/Calendar.png',
              scale: 50,
            ),
          ),
          SizedBox(
            child: Image.asset(
              'assets/icons/Checkmark.png',
              scale: 50,
            ),
          ),
          SizedBox(
            child: Image.asset(
              'assets/icons/Home.png',
              scale: 50,
            ),
          ),
          SizedBox(
            child: Image.asset(
              'assets/icons/Uparrow.png',
              scale: 50,
            ),
          ),
          SizedBox(
            child: Image.asset(
              'assets/icons/Profile.png',
              scale: 50,
            ),
          ),
        ],
        onTap: (value) {
          pageController.animateToPage(value,
              duration: const Duration(microseconds: 100),
              curve: Curves.easeOut);
        },
      ),
    );
  }
}
