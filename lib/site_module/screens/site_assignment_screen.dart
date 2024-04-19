import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echno_attendance/attendance/services/siteassiagnment_service.dart';
import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/services/hr_employee_service.dart';
import 'package:echno_attendance/employee/utilities/employee_role.dart';
import 'package:echno_attendance/site_module/models/site_model.dart';
import 'package:echno_attendance/site_module/services/site_service.dart';
import 'package:echno_attendance/site_module/widgets/employee_autocomplete.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:echno_attendance/utilities/popups/custom_snackbar.dart';
import 'package:flutter/material.dart';

class AssignSiteScreen extends StatefulWidget {
  final SiteOffice siteoffice;
  const AssignSiteScreen({super.key, required this.siteoffice});

  @override
  State<AssignSiteScreen> createState() => _AssignSiteScreenState();
}

class _AssignSiteScreenState extends State<AssignSiteScreen> {
  late SiteOffice siteofficeobj; 
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  List<Employee> _employeeList = [];
  List<Employee> allEmployeesList = [];
  List<Employee> selectedEmployees = [];

  List<String> employeeIdlist = [];
  

  @override
  void initState() {
    super.initState();
    siteofficeobj = widget.siteoffice;
    _initializememberData();
    _initializeallEmployeeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initializememberData() async {
    List<Employee> employees = await employeeObjectListinit();
    setState(() {
      _employeeList = employees;
    });
  }

  Future<void> _initializeallEmployeeData() async {
    List<Employee> allEmployees = await employeeListForAutocomplete();
    setState(() {
      allEmployeesList = allEmployees;
    });
  }

  Future<List<Employee>> employeeObjectListinit() async {
    List<Employee> members = await HrEmployeeService.firestore()
        .populateMemberList(employeeIdList: siteofficeobj.membersList);
    return members;
  }

  Future<List<Employee>> employeeListForAutocomplete() async {
    List<Employee> allEmployees =
        await HrEmployeeService.firestore().getEmployeeAutoComplete();
    return allEmployees;
  }

  void onEmployeeSelect(Employee employee) {
    if (!selectedEmployees.contains(employee)) {
      setState(() {
        selectedEmployees.add(employee);
        employeeIdlist.add(employee.employeeId);
      });
    } else {
      EchnoSnackBar.warningSnackBar(
          context: context,
          title: 'Error',
          message: 'Employee is already selected');
    }
  }

  Future showDeleteDialog(
      BuildContext context, List<String> empString, String siteName) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure you want to delete the employee?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                SiteAssignment(
                  employeeId: empString,
                  siteOfficeName: widget.siteoffice.siteOfficeName,
                ).assignment();
                Navigator.of(context).pop(true);
                setState(() {});
              },
              child: const Text('Delete'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final screenWidth = screenSize.width;
    final isDarkMode = EchnoHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: EchnoAppBar(
        leadingIcon: Icons.arrow_back_ios_new,
        leadingOnPressed: () {
          Navigator.pop(context);
        },
        title: Text('${siteofficeobj.siteOfficeName} Members',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              SizedBox(
                width: screenWidth / 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EmployeeAutoComplete(
                    employees: allEmployeesList,
                    onSelectedEmployeesChanged: onEmployeeSelect,
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await SiteService.firestore().addSiteMember(
                      siteName: siteofficeobj.siteOfficeName,
                      memberList: employeeIdlist,
                    );
                    siteofficeobj =
                        await SiteService.firestore().fetchSpecificSiteOffice(
                      siteOfficeId: siteofficeobj.siteOfficeName,
                    );
                    _initializememberData();
                    setState(() {
                    });
                  },
                  child: const Text('Add'),
                ),
              ))
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8.0,
                  children: [
                    for (int index = 0;
                        index < selectedEmployees.length;
                        index++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Chip(
                          label: Text(selectedEmployees[index].employeeName),
                          onDeleted: () {
                            setState(() {
                              selectedEmployees.removeAt(index);
                              employeeIdlist.removeAt(index);
                            });
                          },
                          deleteIcon: const Icon(
                            Icons.cancel,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Expanded(
              child: _employeeList.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: _employeeList.length,
                      itemBuilder: (context, index) {
                        Employee employee = _employeeList[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            top: 4.0,
                            bottom: 4,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    EchnoSize.borderRadiusLg),
                                color: isDarkMode
                                    ? EchnoColors.attendanceCarddark
                                    : EchnoColors.attendanceCardlight),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: employee.photoUrl != null
                                    ? NetworkImage(employee.photoUrl!)
                                    : null,
                                child: employee.photoUrl == null
                                    ? const Icon(Icons.account_circle, size: 50)
                                    : null,
                              ),
                              title: Text(employee.employeeName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(getEmloyeeRoleName(
                                      employee.employeeRole)),
                                  Text(employee.employeeId),
                                ],
                              ),
                              trailing: Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        EchnoSize.borderRadiusLg),
                                    color: EchnoColors.error),
                                child: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    showDeleteDialog(
                                        context,
                                        [employee.employeeId],
                                        siteofficeobj.siteOfficeName);
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ))
        ],
      ),
    );
  }
}
