import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echno_attendance/attendance/screens/site_assignment_screen.dart';
import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class SiteManage extends StatefulWidget {
  const SiteManage({super.key});

  @override
  State<SiteManage> createState() => _SiteManageState();
}

class _SiteManageState extends State<SiteManage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late ImageProvider siteImage;

  String geturl() {
    return '';
  }

  @override
  void initState() {
    String imageUrl = geturl();
    if (imageUrl != '') {
      siteImage = NetworkImage(geturl());
    } else {
      siteImage =
          const AssetImage('assets/images/istockphoto-1364917563-612x612.jpg');
    }
    super.initState();
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
