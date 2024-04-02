import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/task_module/models/task_model.dart';
import 'package:echno_attendance/task_module/screens/employee_task_screen.dart';
import 'package:echno_attendance/task_module/services/task_service.dart';
import 'package:echno_attendance/task_module/utilities/task_status.dart';
import 'package:echno_attendance/task_module/utilities/task_ui_helpers.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:echno_attendance/utilities/popups/custom_snackbar.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/material.dart';

class UpdateTaskProgessScreen extends StatefulWidget {
  final Task? task;
  const UpdateTaskProgessScreen({
    required this.task,
    super.key,
  });

  @override
  State<UpdateTaskProgessScreen> createState() =>
      _UpdateTaskProgessScreenState();
}

class _UpdateTaskProgessScreenState extends State<UpdateTaskProgessScreen> {
  get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  Task? get task => widget.task;

  final _taskProvider = TaskService.firestoreTasks();

  late TextEditingController _progressController;
  double? _progressSliderValue = 0.0;
  TaskStatus? _selectedTaskStatus;

  @override
  void initState() {
    _progressController =
        TextEditingController(text: widget.task?.taskProgress.toString());
    _progressSliderValue = widget.task?.taskProgress;
    _selectedTaskStatus = widget.task?.status;
    super.initState();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

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
          'Update Progress',
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
              Text('Update Task Progress...',
                  style: Theme.of(context).textTheme.displaySmall),
              Text(
                'Update progress of the task selected...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: EchnoSize.spaceBtwItems),
              const Divider(height: EchnoSize.dividerHeight),
              const SizedBox(height: EchnoSize.spaceBtwItems),
              Column(
                children: [
                  DropdownButtonFormField<TaskStatus>(
                    value: _selectedTaskStatus,
                    onChanged: (TaskStatus? newValue) {
                      setState(() {
                        _selectedTaskStatus = newValue;
                      });
                    },
                    items: TaskStatus.values.map((TaskStatus taskStatus) {
                      String statusName =
                          TaskUiHelpers.getTaskStatusName(taskStatus);
                      return DropdownMenuItem<TaskStatus>(
                        value: taskStatus,
                        child: Text(statusName),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Task Status',
                    ),
                  ),
                  const SizedBox(height: EchnoSize.spaceBtwItems),
                  Text(
                    'Task Progress',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: EchnoSize.defaultSpace / 2),
                  TextFormField(
                    controller: _progressController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _progressSliderValue = double.tryParse(value) ?? 0.0;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Task Progress (%)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: EchnoSize.defaultSpace / 2),
                  Slider(
                    value: _progressSliderValue!,
                    onChanged: (value) {
                      setState(() {
                        _progressSliderValue = value;
                        _progressController.text = value.toStringAsFixed(2);
                      });
                    },
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: _progressSliderValue?.round().toString(),
                  ),
                  const SizedBox(height: EchnoSize.spaceBtwItems),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _taskProvider.updateTaskProgress(
                          taskId: task!.id,
                          newTaskStatus: _selectedTaskStatus.toString(),
                          newTaskProgress: _progressSliderValue,
                        );
                        if (context.mounted) {
                          EchnoSnackBar.successSnackBar(
                              context: context,
                              title: 'Success...!',
                              message:
                                  'Task Progress Updated Successfully...!');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmployeeTaskHomeScreen(
                                  index: TaskUiHelpers.getTaskHomeIndex(
                                      _selectedTaskStatus.toString())),
                            ),
                          );
                        }
                        // Clear the controllers after form submission
                        setState(() {
                          _progressController.clear();
                        });
                      },
                      child: const Text('Update Task Progress'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
