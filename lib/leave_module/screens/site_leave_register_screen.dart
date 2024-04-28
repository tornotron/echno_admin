import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/leave_module/widgets/site_leave_register.dart';
import 'package:echno_attendance/site_module/models/site_model.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/material.dart';

class SiteLeaveRegisterScreen extends StatelessWidget {
  final SiteOffice siteOffice;
  const SiteLeaveRegisterScreen({
    required this.siteOffice,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Leave Management',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: FutureBuilder<Employee>(
          future: null,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Padding(
                padding: CustomPaddingStyle.defaultPaddingWithAppbar,
                child: SiteLeaveRegister(
                    siteOffice: siteOffice, currentEmployee: snapshot.data!),
              );
            } else {
              return const Center(child: Text('No data found'));
            }
          }),
    );
  }
}
