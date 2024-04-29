import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/employee/hr_bloc/hr_bloc.dart';
import 'package:echno_attendance/employee/hr_bloc/hr_event.dart';
import 'package:echno_attendance/site_module/bloc/site_bloc.dart';
import 'package:echno_attendance/site_module/bloc/site_event.dart';
import 'package:echno_attendance/site_module/models/site_model.dart';
import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/site_module/services/site_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SiteManagementScreen extends StatefulWidget {
  const SiteManagementScreen({super.key});

  @override
  State<SiteManagementScreen> createState() => _SiteManagementScreenState();
}

class _SiteManagementScreenState extends State<SiteManagementScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late ImageProvider siteImage;
  final formKey = GlobalKey<FormState>();

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
    return Scaffold(
        appBar: EchnoAppBar(
          leadingIcon: Icons.arrow_back_ios_new,
          leadingOnPressed: () {
            context.read<HrBloc>().add(const HrDashboardEvent());
          },
          title: Text('Site Management',
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        body: StreamBuilder<List<SiteOffice>>(
          stream: SiteService.firestore().fetchSiteOffices(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No site data found...',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              final List<SiteOffice> siteOffices = snapshot.data!;

              return GridView.builder(
                itemCount: siteOffices.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  final siteOffice = siteOffices[index];
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
                        alignment: Alignment.bottomCenter,
                        children: [
                          InkWell(
                            onLongPress: () {},
                            onTap: () {
                              context
                                  .read<SiteBloc>()
                                  .add(SiteHomeEvent(siteOffice: siteOffice));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              siteOffice.siteOfficeName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 24,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: EchnoColors.selectedNavLight,
          onPressed: () {
            context.read<SiteBloc>().add(const SiteCreateEvent());
          },
          child: const Icon(
            Icons.add,
            color: EchnoColors.white,
          ),
        ));
  }
}
