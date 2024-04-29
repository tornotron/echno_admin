import 'package:dropdown_search/dropdown_search.dart';
import 'package:echno_attendance/employee/widgets/attcard_monthly.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MonthlyReport extends StatefulWidget {
  const MonthlyReport({super.key});

  @override
  State<MonthlyReport> createState() => _MonthlyReportState();
}

class _MonthlyReportState extends State<MonthlyReport> {
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  late String _employeeIdfromUI = '';
  late String _attendanceMonthfromUI = '';
  late String _attendanceYearfromUI = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Monthly Attendance Report',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontSize: 29)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 13.7),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Get monthly attendance report',
                style: Theme.of(context).textTheme.titleMedium),
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
                child: TextFormField(
                  controller: _employeeIdController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: 'Emp ID',
                      labelStyle: Theme.of(context).textTheme.titleMedium),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownSearch<String>(
                  popupProps: const PopupProps.menu(
                    showSelectedItems: true,
                  ),
                  items: const [
                    "January",
                    "February",
                    "March",
                    "April",
                    "May",
                    "June",
                    "July",
                    "August",
                    "September",
                    "October",
                    "November",
                    "December"
                  ],
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: 'Month',
                      labelStyle: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  onChanged: (value) {
                    if (value == null) {
                    } else {
                      setState(() {
                        _attendanceMonthfromUI = value;
                      });
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _yearController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    labelText: 'Year',
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
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
              if (_employeeIdController.text.isNotEmpty &&
                  _attendanceMonthfromUI.isNotEmpty &&
                  _yearController.text.isNotEmpty) {
                setState(() {
                  _employeeIdfromUI = _employeeIdController.text;
                  _attendanceYearfromUI = _yearController.text;
                });
              }
            },
            child: const Text(
              'Submit',
              style: TextStyle(
                fontFamily: 'TT Chocolates',
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          child: _employeeIdfromUI.isNotEmpty &&
                  _attendanceMonthfromUI.isNotEmpty &&
                  _attendanceYearfromUI.isNotEmpty
              ? AttendanceCardMonthly(
                  employeeId: _employeeIdfromUI,
                  attendanceMonth: _attendanceMonthfromUI,
                  attYear: _attendanceYearfromUI,
                )
              : Container(
                  color: Colors.white,
                ),
        ),
      ],
    );
  }
}
