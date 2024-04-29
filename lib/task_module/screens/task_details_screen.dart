import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/site_module/models/site_model.dart';
import 'package:echno_attendance/task_module/bloc/task_bloc.dart';
import 'package:echno_attendance/task_module/bloc/task_event.dart';
import 'package:echno_attendance/task_module/models/task_model.dart';
import 'package:echno_attendance/task_module/screens/update_task_progress_screen.dart';
import 'package:echno_attendance/task_module/utilities/task_ui_helpers.dart';
import 'package:echno_attendance/task_module/widgets/task_details_form.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task? task;
  final SiteOffice? siteOffice;
  const TaskDetailsScreen({
    required this.task,
    super.key,
    this.siteOffice,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  Task? get task => widget.task;

  // Controllers for text form fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _createdDateController = TextEditingController();
  final TextEditingController _taskAuthorController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // Controllers for dropdowns
  final TextEditingController _taskTypeController = TextEditingController();
  final TextEditingController _assignedEmployeeController =
      TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  // Controller for linear progress indicator
  final TextEditingController _taskProgressController = TextEditingController();

  double? taskProgress; // For Linear Progress Indicator

  @override
  void initState() {
    _titleController.text = task?.title ?? "";
    _descriptionController.text = task?.description ?? "";
    _createdDateController.text = TaskUiHelpers.formatDate(task?.createdAt);
    _taskAuthorController.text = task?.taskAuthor ?? "";
    _startDateController.text = TaskUiHelpers.formatDate(task?.startDate);
    _endDateController.text = TaskUiHelpers.formatDate(task?.endDate);
    _taskTypeController.text = TaskUiHelpers.getTaskTypeName(task?.taskType);
    _assignedEmployeeController.text = task?.assignedEmployee ?? "";
    _statusController.text = TaskUiHelpers.getTaskStatusName(task?.status);
    _taskProgressController.text = task?.taskProgress.toString() ?? "";
    taskProgress = task?.taskProgress != null ? task!.taskProgress / 100 : null;
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _createdDateController.dispose();
    _taskAuthorController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _taskTypeController.dispose();
    _assignedEmployeeController.dispose();
    _statusController.dispose();
    _taskProgressController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    final isDark = EchnoHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: EchnoAppBar(
        leadingIcon: Icons.arrow_back_ios_new,
        leadingOnPressed: () {
          if (widget.siteOffice == null) {
            Navigator.of(context).pop();
          } else {
            context
                .read<TaskBloc>()
                .add(TaskHomeEvent(siteOffice: widget.siteOffice!));
          }
        },
        title: Text('Task Details',
            style: Theme.of(context).textTheme.headlineSmall),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return UpdateTaskProgessScreen(task: task);
              }));
            },
            icon: Icon(Icons.edit,
                color: isDark ? EchnoColors.white : EchnoColors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: CustomPaddingStyle.defaultPaddingWithAppbar,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Task Details...',
                  style: Theme.of(context).textTheme.displaySmall),
              Text('Detailed information of the task selected...',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.left),
              const SizedBox(height: EchnoSize.spaceBtwItems),
              const Divider(height: EchnoSize.dividerHeight),
              const SizedBox(height: EchnoSize.spaceBtwItems),
              TaskDetailFormWidget(
                titleController: _titleController,
                descriptionController: _descriptionController,
                createdDateController: _createdDateController,
                taskAuthorController: _taskAuthorController,
                startDateController: _startDateController,
                endDateController: _endDateController,
                taskTypeController: _taskTypeController,
                statusController: _statusController,
                taskProgress: taskProgress,
                task: task,
                assignedEmployeeController: _assignedEmployeeController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
