import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echno_attendance/site_module/screens/create_site_screen.dart';
import 'package:echno_attendance/attendance/services/sitecreation_service.dart';
import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/site_module/screens/site_assignment_screen.dart';
import 'package:echno_attendance/utilities/helpers/device_helper.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class SiteManage extends StatefulWidget {
  const SiteManage({super.key});

  @override
  State<SiteManage> createState() => _SiteManageState();
}

class _SiteManageState extends State<SiteManage> {
  late final TextEditingController _addSitecontroller;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late ImageProvider siteImage;
  final formKey = GlobalKey<FormState>();

  String geturl() {
    return '';
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
                        controller: _addSitecontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the Site name';
                          }
                          return null;
                        },
                        enableSuggestions: false,
                        autocorrect: false,
                        maxLines: 1,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline_outlined),
                          labelText: 'Site name',
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
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await SiteCreate(
                                      siteName: _addSitecontroller.text)
                                  .creation();
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

  @override
  void initState() {
    _addSitecontroller = TextEditingController();
    String imageUrl = geturl();
    if (imageUrl != '') {
      siteImage = NetworkImage(geturl());
    } else {
      siteImage =
          const AssetImage('assets/images/istockphoto-1364917563-612x612.jpg');
    }
    super.initState();
  }

  void selectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const CreateSiteScreen();
        }));
        break;
      case 1:
        print("clicked 1");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = EchnoHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: EchnoAppBar(
        leadingIcon: Icons.arrow_back_ios_new,
        leadingOnPressed: () {
          Navigator.pop(context);
        },
        title: Text(
          'Site Management',
          style: Theme.of(context).textTheme.headlineSmall?.apply(
                color: isDark ? EchnoColors.black : EchnoColors.white,
              ),
        ),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text(
                  'Create new site',
                  style: Theme.of(context).textTheme.bodyLarge?.apply(
                        color: isDark ? EchnoColors.white : EchnoColors.black,
                      ),
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text(
                  'Delete site',
                  style: Theme.of(context).textTheme.bodyLarge?.apply(
                        color: isDark ? EchnoColors.white : EchnoColors.black,
                      ),
                ),
              ),
            ],
            onSelected: (item) {
              selectedItem(context, item);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: firestore.collection('site').get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final gridcount = snapshot.data?.docs.length;
              List<DocumentSnapshot> documents = snapshot.data!.docs;
              return GridView.builder(
                itemCount: gridcount,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  final String siteName = documents[index].id;
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey,
                        image: DecorationImage(
                            image: siteImage, fit: BoxFit.cover),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          InkWell(
                            onLongPress: () {},
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return AssignSiteScreen(sitename: siteName);
                                  },
                                ),
                              );
                            },
                          ),
                          Text(
                            siteName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
