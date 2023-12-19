import 'package:echno_attendance/auth/services/auth_service.dart';
import 'package:echno_attendance/constants/colors_string.dart';
import 'package:echno_attendance/leave_module/services/leave_services.dart';
import 'package:flutter/material.dart';

class LeaveApplicationScreen extends StatefulWidget {
  const LeaveApplicationScreen({Key? key}) : super(key: key);
  static const EdgeInsetsGeometry containerPadding =
      EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0);

  @override
  State<LeaveApplicationScreen> createState() => _LeaveApplicationScreenState();
}

class _LeaveApplicationScreenState extends State<LeaveApplicationScreen> {
  get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  final TextEditingController _remarksController = TextEditingController();
  final currentUserId =
      AuthService.firebase().currentUser?.uid; // Current user uid
  final leaveProvider = LeaveService.firestoreLeave(); // Leave related services
  Map<String, dynamic>? employeeData; // Variable to store current user data

  DateTime? startDate; // Starting date of leave
  DateTime? endDate; // Ending date of leave

  String?
      selectedLeaveType; // Variable to store selected leave type using radio buttons

  // List of leave types to be displayed in radio buttons
  List<String> leaveType = [
    "Casual Leave",
    "Medical Leave",
    "Maternity Leave",
    "Annual Leave",
  ];

  // Function selects the start date of leave
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      if (picked.isBefore(DateTime.now())) {
        // Show error dialog for start date before current date
        _showErrorDialog('Start date cannot be before the current date');
      } else {
        setState(() {
          startDate = picked;
          endDate = null; // Reset end date when start date changes
        });
      }
    }
  }

  // Function selects the end date of leave
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && startDate != null) {
      if (picked.isBefore(startDate!)) {
        _showErrorDialog('End date cannot be before the start date');
      } else {
        setState(() {
          endDate = picked;
        });
      }
    }
  }

  // Function to calculate the number of days on leave
  String? calculateLeaveDays() {
    if (startDate != null && endDate != null) {
      return (endDate!.difference(startDate!).inDays + 1).toString();
    } else {
      return '-';
    }
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              Text('Error'),
            ],
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkMode ? echnoLightBlueColor : echnoLogoColor,
          title: const Text('Leave Application'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: LeaveApplicationScreen.containerPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Leave Application...',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.left,
                ),
                Text(
                  'Application to request leave...',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10.0),
                const Divider(height: 3.0),
                const SizedBox(height: 10.0),

                // The immediate supervisor of the employee
                Text(
                  'Site Co-Ordinator',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  enabled: false,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Alex Mercer', // This should be fetched from DB
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                    border: const OutlineInputBorder(),
                  ),
                  onTap: () {},
                ),
                const SizedBox(height: 10.0),

                // Current Date
                Text(
                  "Today's Date",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 5.0),
                TextField(
                  readOnly: true,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText:
                        '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                    labelStyle: Theme.of(context).textTheme.titleMedium,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10.0),

                // Selection field the start date of leave
                Text(
                  'Leave From',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 5.0),
                GestureDetector(
                  child: TextFormField(
                    readOnly: true,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: startDate == null
                          ? 'Select Start Date'
                          : "${startDate!.day}-${startDate!.month}-${startDate!.year}",
                      labelStyle: Theme.of(context).textTheme.titleMedium,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  onTap: () {
                    _selectStartDate(context);
                  },
                ),
                const SizedBox(height: 10.0),

                // Selection field the end date of leave
                Text(
                  'Leave Till',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 5.0),
                GestureDetector(
                  child: TextFormField(
                    readOnly: true,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: endDate == null
                          ? 'Select End Date'
                          : "${endDate!.day}-${endDate!.month}-${endDate!.year}",
                      labelStyle: Theme.of(context).textTheme.titleMedium,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  onTap: () {
                    _selectEndDate(context);
                  },
                ),
                const SizedBox(height: 10.0),

                // Number of days on leave calculated from start and end date
                Text(
                  'Nuber of days on leave :  ${calculateLeaveDays()}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10.0),

                // Radio Buttons to select Leave Type
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: echnoGreyColor,
                      width: 1.50,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Leave Type',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 5.0),
                      Column(
                        children: leaveType.map((type) {
                          return RadioListTile<String>(
                            title: Text(type),
                            value: type,
                            groupValue: selectedLeaveType,
                            onChanged: (value) {
                              setState(() {
                                selectedLeaveType = value;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),

                // Text field to enter remarks
                Text(
                  'Remarks',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 5.0),
                TextField(
                  controller: _remarksController,
                  minLines: 5,
                  maxLines: null, // Allows for an adjustable number of lines
                  decoration: const InputDecoration(
                    hintText: 'Enter Remarks...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15.0),

                // Button to submit leave application
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (currentUserId != null) {
                        employeeData = await leaveProvider.searchEmployeeByUID(
                            uid: currentUserId!);
                      }
                      await leaveProvider.applyForLeave(
                        uid: currentUserId!,
                        employeeID: employeeData!['employee-id'],
                        employeeName: employeeData!['full-name'],
                        appliedDate:
                            '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                        fromDate:
                            "${startDate!.day}-${startDate!.month}-${startDate!.year}",
                        toDate:
                            "${endDate!.day}-${endDate!.month}-${endDate!.year}",
                        leaveType: selectedLeaveType,
                        remarks: _remarksController.text,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green.shade600,
                            content: const Text('Leave application submitted'),
                          ),
                        );
                      }

                      // Clear the fields on successful submission of leave
                      setState(() {
                        _remarksController.clear();
                        startDate = null;
                        endDate = null;
                        selectedLeaveType = null;
                      });
                    },
                    child: const Text(
                      'APPLY FOR LEAVE',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}