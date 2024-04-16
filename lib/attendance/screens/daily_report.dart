import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:date_picker_timeline/extra/style.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/employee/widgets/attcard_daily.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyReport extends StatefulWidget {
  const DailyReport({
    super.key,
  });

  @override
  State<DailyReport> createState() => _DailyState();
}

class _DailyState extends State<DailyReport> {
  TextEditingController siteController = TextEditingController();
  DatePickerController datevisualController = DatePickerController();
  DateTime currentDate = DateTime.now();
  late String currentDateString = DateFormat('yyyy-MM-dd').format(currentDate);

  void _scrolltoday() {
    datevisualController.animateToDate(DateTime.now());
  }

  String siteNamefromUI = '';
  late String dateFromUI = currentDateString;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = EchnoHelperFunctions.isDarkMode(context);
    return Column(
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
          height: 5,
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: siteController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: 'Enter Employee Site Name',
                      labelStyle: Theme.of(context).textTheme.titleMedium),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 90,
                width: 300,
                child: DatePicker(
                  DateTime.now().subtract(const Duration(days: 30)),
                  initialSelectedDate: DateTime.now(),
                  controller: datevisualController,
                  monthTextStyle: defaultMonthTextStyle.copyWith(
                      color:
                          isDarkMode ? EchnoColors.white : EchnoColors.black),
                  dateTextStyle: defaultDateTextStyle.copyWith(
                      color:
                          isDarkMode ? EchnoColors.white : EchnoColors.black),
                  dayTextStyle: defaultDayTextStyle.copyWith(
                      color:
                          isDarkMode ? EchnoColors.white : EchnoColors.black),
                  selectionColor: isDarkMode
                      ? EchnoColors.selectedNavDark
                      : EchnoColors.selectedNavLight,
                  selectedTextColor: Colors.white,
                  onDateChange: (selectedDate) {
                    dateFromUI = DateFormat('yyyy-MM-dd').format(selectedDate);
                  },
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            SizedBox(
              width: 90,
              child: ElevatedButton(
                onPressed: () {
                  _scrolltoday();
                },
                child: const Text(
                  "Reset",
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 250,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                siteNamefromUI = siteController.text;
                dateFromUI;
              });
            },
            child: const Text(
              'Submit',
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        AttendanceCardDaily(siteName: siteNamefromUI, date: dateFromUI),
      ],
    );
  }
}
