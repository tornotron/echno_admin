import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/leave_module_strings.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/employee/bloc/employee_bloc.dart';
import 'package:echno_attendance/employee/bloc/employee_event.dart';
import 'package:echno_attendance/leave_module/screens/leave_application_screen.dart';
import 'package:echno_attendance/leave_module/widgets/status_stream_builder.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class LeaveStatusScreen extends StatefulWidget {
  const LeaveStatusScreen({super.key});

  @override
  State<LeaveStatusScreen> createState() => LeaveStatusScreenState();
}

class LeaveStatusScreenState extends State<LeaveStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EchnoAppBar(
        leadingIcon: Icons.arrow_back_ios_new,
        leadingOnPressed: () {
          context
              .read<EmployeeBloc>()
              .add(const EmployeeProfileEvent(section: 'profile_home_section'));
        },
        title: Text('Leave Status',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Column(
        children: [
          Padding(
            padding: CustomPaddingStyle.defaultPaddingWithAppbar,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat.yMMMMd().format(DateTime.now()),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text('Today',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20.0,
                                )),
                      ],
                    ),
                    SizedBox(
                      width: 130.0,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const LeaveApplicationScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          '+ Apply Leave',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: EchnoSize.spaceBtwSections),
                Text(
                  leaveStatusScreenTitle,
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.left,
                ),
                Text(
                  leaveStatusSubtitle,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: EchnoSize.spaceBtwItems),
                const Divider(height: EchnoSize.dividerHeight),
              ],
            ),
          ),
          const LeaveStatusStreamWidget(),
        ],
      ),
    );
  }
}
