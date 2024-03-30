import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echno_attendance/attendance/services/siteEmpAdd_service.dart';
import 'package:echno_attendance/attendance/services/siteassiagnment_service.dart';
import 'package:echno_attendance/constants/colors_string.dart';
import 'package:echno_attendance/employee/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AssignSiteScreen extends StatefulWidget {
  const AssignSiteScreen({super.key, required this.sitename});
  final String sitename;

  @override
  State<AssignSiteScreen> createState() => _AssignSiteScreenState();
}

class _AssignSiteScreenState extends State<AssignSiteScreen> {
  late final TextEditingController _addEmpcontroller;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double adjustedMaxChildSize =
        1.0 - (keyboardHeight / MediaQuery.of(context).size.height);
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.33,
        maxChildSize: keyboardHeight > 0 ? adjustedMaxChildSize : 1.0,
        minChildSize: 0.32,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(bottom: keyboardHeight),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  SizedBox(
                    height: 60,
                    width: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _addEmpcontroller,
                        enableSuggestions: false,
                        autocorrect: false,
                        maxLines: 1,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline_outlined),
                          labelText: 'Employee ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    width: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            SiteEmpAdd(
                                    empId: _addEmpcontroller.text,
                                    siteOfficeName: widget.sitename)
                                .assignment();
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: echnoBlueColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              fontFamily: 'TT Chocolates',
                              color: Colors.white,
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final screenWidth = screenSize.width;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF004AAD),
        ),
        backgroundColor: echnoBlueColor,
        title: Texts(
          textData: widget.sitename,
          textFontSize: 23,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
        ),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: echnoBlueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      textStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    child: const Text(
                      'Add Employee',
                      style: TextStyle(
                        fontFamily: 'TT Chocolates',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: echnoBlueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    textStyle: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  child: const Text(
                    '',
                    style: TextStyle(
                      fontFamily: 'TT Chocolates',
                      color: Colors.white,
                    ),
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
                                        onTap: () {
                                          empList.removeAt(index);
                                          List<String> empString = empList
                                              .map((dynamic item) =>
                                                  item.toString())
                                              .toList();
                                          SiteAssignment(
                                                  employeeId: empString,
                                                  siteOfficeName:
                                                      widget.sitename)
                                              .assignment();
                                          setState(() {});
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
