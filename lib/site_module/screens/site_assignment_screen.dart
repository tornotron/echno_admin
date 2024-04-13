import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echno_attendance/attendance/services/siteassiagnment_service.dart';
import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/colors_string.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/site_module/services/siteEmpAdd_service.dart';
import 'package:echno_attendance/utilities/helpers/device_helper.dart';
import 'package:flutter/material.dart';

class AssignSiteScreen extends StatefulWidget {
  const AssignSiteScreen({super.key, required this.sitename});
  final String sitename;

  @override
  State<AssignSiteScreen> createState() => _AssignSiteScreenState();
}

class _AssignSiteScreenState extends State<AssignSiteScreen> {
  late final TextEditingController _addEmpcontroller;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _addEmpcontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _addEmpcontroller.dispose();
    super.dispose();
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
                                      siteOfficeName: widget.sitename)
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
                  siteOfficeName: widget.sitename,
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
    return Scaffold(
      appBar: EchnoAppBar(
        leadingIcon: Icons.arrow_back_ios_new,
        leadingOnPressed: () {
          Navigator.pop(context);
        },
        title: Text('${widget.sitename} Members',
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
            child: FutureBuilder(
              future: firestore.collection('site').doc(widget.sitename).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data!.id.isEmpty) {
                  return Container(
                    color: Colors.white,
                  );
                } else {
                  final List<dynamic> empList =
                      snapshot.data!.get('employee-list');
                  return ListView.builder(
                    itemCount: empList.length,
                    itemBuilder: (context, index) {
                      if (empList[0] == "") {
                        return Container(
                          color: Colors.white,
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: screenWidth,
                            height: 80,
                            decoration: BoxDecoration(
                              color: echnoBlueLightColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      empList[index],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'TT Chocolates',
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 100,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: InkWell(
                                        onTap: () async {
                                          empList.removeAt(index);
                                          List<String> empString = empList
                                              .map((dynamic item) =>
                                                  item.toString())
                                              .toList();
                                          await showDeleteDialog(context,
                                              empString, widget.sitename);
                                        },
                                        child: const Center(
                                          child: Icon(Icons.delete_outline),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
