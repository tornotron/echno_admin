import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/site_module/models/site_model.dart';
import 'package:echno_attendance/task_module/bloc/task_bloc.dart';
import 'package:echno_attendance/task_module/bloc/task_event.dart';
import 'package:echno_attendance/task_module/widgets/add_task_form.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTaskScreen extends StatelessWidget {
  final SiteOffice siteOffice;
  const AddTaskScreen({
    required this.siteOffice,
    super.key,
  });

  @override
  Widget build(context) {
    return Scaffold(
      appBar: EchnoAppBar(
        leadingIcon: Icons.arrow_back_ios_new,
        leadingOnPressed: () {
          context.read<TaskBloc>().add(TaskHomeEvent(siteOffice: siteOffice));
        },
        title: Text('Create Task',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: CustomPaddingStyle.defaultPaddingWithAppbar,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create New Task',
                  style: Theme.of(context).textTheme.displaySmall),
              Text(
                'Create a new task to work on...',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: EchnoSize.spaceBtwItems),
              const Divider(height: EchnoSize.dividerHeight),
              const SizedBox(height: EchnoSize.spaceBtwItems),
              AddTaskForm(
                siteOffice: siteOffice,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
