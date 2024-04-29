import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/site_module/bloc/site_bloc.dart';
import 'package:echno_attendance/site_module/bloc/site_event.dart';
import 'package:echno_attendance/site_module/widgets/create_site_form.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateSiteScreen extends StatelessWidget {
  const CreateSiteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EchnoAppBar(
        leadingIcon: Icons.arrow_back_ios_new,
        leadingOnPressed: () {
          context.read<SiteBloc>().add(const SiteManagementDashboardEvent());
        },
        title: Text('Create Site',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: CustomPaddingStyle.defaultPaddingWithAppbar,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('New Site Office',
                    style: Theme.of(context).textTheme.displaySmall),
                Text(
                  'Create new site or project...',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: EchnoSize.spaceBtwSections),
                const CreateSiteForm()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
