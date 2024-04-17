import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echno_attendance/attendance/services/siteassiagnment_service.dart';
import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/services/hr_employee_service.dart';
import 'package:echno_attendance/employee/utilities/employee_role.dart';
import 'package:echno_attendance/site_module/models/site_model.dart';
import 'package:echno_attendance/site_module/services/siteEmpAdd_service.dart';
import 'package:echno_attendance/utilities/helpers/device_helper.dart';
import 'package:flutter/material.dart';

class AssignSiteScreen extends StatefulWidget {
  final SiteOffice siteoffice;
  const AssignSiteScreen({super.key, required this.siteoffice});

  @override
  State<AssignSiteScreen> createState() => _AssignSiteScreenState();
}

class _AssignSiteScreenState extends State<AssignSiteScreen> {
  late final TextEditingController _addEmpcontroller;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  List<Employee> _employeeList = [];

  @override
  void initState() {
    _addEmpcontroller = TextEditingController();
    _initializeData();
    super.initState();
  }

  @override
  void dispose() {
    _addEmpcontroller.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    List<Employee> employees = await employeeObjectListinit();
    setState(() {
      _employeeList = employees;
    });
  }

  Future<List<Employee>> employeeObjectListinit() async {
    List<Employee> members = await HrEmployeeService.firestore()
        .populateMemberList(employeeIdList: widget.siteoffice.membersList);
    return members;
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(EchnoSize.borderRadiusLg),
      ),
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: DeviceUtilityHelpers.getKeyboardHeight(context),
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 40, left: 20, right: 20, bottom: 40),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _addEmpcontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the employee ID';
                          }
                          return null;
                        },
                        enableSuggestions: false,
                        autocorrect: false,
                        maxLines: 1,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline_outlined),
                          labelText: 'Employee ID',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(EchnoSize.borderRadiusLg),
                          ),
                        ),
                      ),
                      const SizedBox(height: EchnoSize.spaceBtwItems),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              SiteEmpAdd(
                                      empId: _addEmpcontroller.text,
                                      siteOfficeName:
                                          widget.siteoffice.siteOfficeName)
                                  .assignment();
                              setState(() {});
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'Submit',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
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
    // final mediaQuery = MediaQuery.of(context);
    // final screenSize = mediaQuery.size;
    // final screenWidth = screenSize.width;
    return Scaffold(
      appBar: EchnoAppBar(
        leadingIcon: Icons.arrow_back_ios_new,
        leadingOnPressed: () {
          Navigator.pop(context);
        },
        title: Text('${widget.siteoffice.siteOfficeName} Members',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _showBottomSheet(context);
                    },
                    child: const Text(
                      'Add Employee',
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    '',
                  ),
                ),
              )),
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
                              color: EchnoColors.accent),
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
                                Text(getEmloyeeRoleName(employee.employeeRole)),
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
                                      widget.siteoffice.siteOfficeName);
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
