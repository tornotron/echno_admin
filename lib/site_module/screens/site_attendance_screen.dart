import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:date_picker_timeline/extra/style.dart';
import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/employee/widgets/attcard_daily.dart';
import 'package:echno_attendance/site_module/models/site_model.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SiteAttendanceReport extends StatefulWidget {
  final SiteOffice siteOffice;
  const SiteAttendanceReport({
    required this.siteOffice,
    super.key,
  });

  @override
  State<SiteAttendanceReport> createState() => _DailyState();
}

class _DailyState extends State<SiteAttendanceReport> {
  TextEditingController siteController = TextEditingController();
  DatePickerController datevisualController = DatePickerController();
  DateTime currentDate = DateTime.now();
  late String currentDateString = DateFormat('yyyy-MM-dd').format(currentDate);

  void _scrolltoday() {
    datevisualController.animateToDate(DateTime.now());
  }

  late String dateFromUI = currentDateString;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = EchnoHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: EchnoAppBar(
        leadingIcon: Icons.arrow_back_ios_new,
        leadingOnPressed: () {
          Navigator.pop(context);
        },
        title: Text('${widget.siteOffice.siteOfficeName} Report',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 20),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Daily Attendance Report',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(fontSize: 29))),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13.7),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Get daily attendance report',
                    style: Theme.of(context).textTheme.titleMedium)),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 90,
            width: 400,
            child: DatePicker(
              DateTime.now().subtract(const Duration(days: 30)),
              initialSelectedDate: DateTime.now(),
              controller: datevisualController,
              monthTextStyle: defaultMonthTextStyle.copyWith(
                  color: isDarkMode ? EchnoColors.white : EchnoColors.black),
              dateTextStyle: defaultDateTextStyle.copyWith(
                  color: isDarkMode ? EchnoColors.white : EchnoColors.black),
              dayTextStyle: defaultDayTextStyle.copyWith(
                  color: isDarkMode ? EchnoColors.white : EchnoColors.black),
              selectionColor: isDarkMode
                  ? EchnoColors.selectedNavDark
                  : EchnoColors.selectedNavLight,
              selectedTextColor: Colors.white,
              onDateChange: (selectedDate) {
                dateFromUI = DateFormat('yyyy-MM-dd').format(selectedDate);
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        dateFromUI;
                      });
                    },
                    child: const Text(
                      'Submit',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _scrolltoday();
                    },
                    child: const Text(
                      "Reset",
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          AttendanceCardDaily(
            siteName: widget.siteOffice.siteOfficeName,
            date: dateFromUI,
          ),
        ],
      ),
    );
  }
}
