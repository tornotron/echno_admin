import 'package:echno_attendance/attendance/services/attendance_insertservice.dart';
import 'package:echno_attendance/camera/camera_provider.dart';
import 'package:echno_attendance/camera/take_picture_screen.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/employee/bloc/employee_bloc.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/widgets/rounded_card.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slide_to_act/slide_to_act.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  late final Employee currentEmployee;
  @override
  Widget build(BuildContext context) {
    final isDark = EchnoHelperFunctions.isDarkMode(context);
    final currentEmployee = context.select((EmployeeBloc bloc) {
      return bloc.currentEmployee;
    });
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
                backgroundColor: isDark
                    ? EchnoColors.secondaryDark
                    : EchnoColors.primaryLight,
                expandedHeight: 200,
                floating: true,
                pinned: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                flexibleSpace: const FlexibleSpaceBar(
                  background: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome",
                            style: TextStyle(fontSize: 28),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Site Name",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 2.5,
                          ),
                          Text(
                            "Site Location",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
            const SliverToBoxAdapter(
              child: SizedBox(height: 25),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 70),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return const Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 5,
                            right: 5,
                          ),
                          child: RoundedCard(),
                        ),
                        SizedBox(
                          height: 5,
                        )
                      ],
                    );
                  },
                  childCount: 9,
                ),
              ),
            )
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 85),
            child: SlideAction(
              elevation: 0,
              innerColor: EchnoColors.white,
              outerColor: isDark ? EchnoColors.secondary : EchnoColors.primary,
              text: 'Slide to mark attendance',
              textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark ? EchnoColors.black : EchnoColors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
              sliderRotate: false,
              borderRadius: 20,
              sliderButtonIcon: const Icon(
                Icons.camera_alt,
                color: EchnoColors.black,
              ),
              onSubmit: () async {
                await AttendanceInsertionService().attendanceTrigger(
                    employeeId: currentEmployee.employeeId,
                    employeeName: currentEmployee.employeeName,
                    siteName: "delhi");
                final frontCamera = await cameraObjectProvider();
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        TakePictureScreen(camera: frontCamera),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
