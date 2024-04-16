import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/site_module/models/site_model.dart';
import 'package:echno_attendance/site_module/screens/site_assignment_screen.dart';
import 'package:echno_attendance/site_module/widgets/site_menu_widget.dart';
import 'package:echno_attendance/task_module/screens/task_home_screen.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/material.dart';

class SiteHomeScreen extends StatefulWidget {
  final SiteOffice siteOffice;
  const SiteHomeScreen({
    required this.siteOffice,
    super.key,
  });

  @override
  State<SiteHomeScreen> createState() => _SiteHomeScreenState();
}

class _SiteHomeScreenState extends State<SiteHomeScreen> {
  late SiteOffice siteOffice = widget.siteOffice;
  @override
  Widget build(BuildContext context) {
    final isDark = EchnoHelperFunctions.isDarkMode(context);
    return Scaffold(
        appBar: EchnoAppBar(
          leadingIcon: Icons.arrow_back_ios_new,
          leadingOnPressed: () {
            Navigator.pop(context);
          },
          title: Text(siteOffice.siteOfficeName,
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: CustomPaddingStyle.defaultPaddingWithAppbar,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${siteOffice.siteOfficeName} Site',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: EchnoSize.spaceBtwItems),
                const Divider(height: EchnoSize.dividerHeight),
                const SizedBox(height: EchnoSize.spaceBtwItems),
                SiteMenuWidget(
                  isDark: isDark,
                  icon: Icons.playlist_add_check_circle_sharp,
                  title: 'Attendance',
                  onPressed: () {},
                ),
                SiteMenuWidget(
                  isDark: isDark,
                  icon: Icons.task_outlined,
                  title: 'Tasks',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TaskHomeScreen(
                        siteOffice: siteOffice,
                      );
                    }));
                  },
                ),
                SiteMenuWidget(
                  isDark: isDark,
                  icon: Icons.people_outline,
                  title: 'Site Members',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AssignSiteScreen(
                        sitename: siteOffice.siteOfficeName,
                      );
                    }));
                  },
                ),
                SiteMenuWidget(
                  isDark: isDark,
                  icon: Icons.info_outline,
                  title: 'Site Info',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ));
  }
}
