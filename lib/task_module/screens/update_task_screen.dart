import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/task_module/models/task_model.dart';
import 'package:echno_attendance/task_module/widgets/update_task_form.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/material.dart';

class UpdateTaskScreen extends StatelessWidget {
  final Task? task;
  const UpdateTaskScreen({
    required this.task,
    super.key,
  });

  @override
  Widget build(context) {
    final isDark = EchnoHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: EchnoAppBar(
        leadingIcon: Icons.arrow_back_ios_new,
        leadingOnPressed: () {
          Navigator.pop(context);
        },
        title: Text(
          'Update Task',
          style: Theme.of(context).textTheme.headlineSmall?.apply(
                color: isDark ? EchnoColors.black : EchnoColors.white,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: CustomPaddingStyle.defaultPaddingWithAppbar,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Update Task...',
                  style: Theme.of(context).textTheme.displaySmall),
              Text(
                'Update information of the task selected...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: EchnoSize.spaceBtwItems),
              const Divider(height: EchnoSize.dividerHeight),
              const SizedBox(height: EchnoSize.spaceBtwItems),
              UpdateTaskFormWidget(task: task)
            ],
          ),
        ),
      ),
    );
  }
}
