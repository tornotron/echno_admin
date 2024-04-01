import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/task_module/models/task_model.dart';
import 'package:echno_attendance/task_module/screens/task_home_screen.dart';
import 'package:echno_attendance/task_module/services/task_service.dart';
import 'package:echno_attendance/task_module/utilities/task_status.dart';
import 'package:echno_attendance/task_module/utilities/task_types.dart';
import 'package:echno_attendance/task_module/utilities/task_ui_helpers.dart';
import 'package:echno_attendance/utilities/popups/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateTaskFormWidget extends StatefulWidget {
  final Task? task;
  const UpdateTaskFormWidget({
    required this.task,
    super.key,
  });

  @override
  State<UpdateTaskFormWidget> createState() => _UpdateTaskFormWidgetState();
}

class _UpdateTaskFormWidgetState extends State<UpdateTaskFormWidget> {
  Task? get task => widget.task;

  final _taskService = TaskService.firestoreTasks();

  // Controllers for text form fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _createdDateController = TextEditingController();
  final TextEditingController _taskAuthorController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _assignedEmployeeController =
      TextEditingController();

  // Variables to store dropdowns field values
  TaskType? _selectedTaskType;
  TaskStatus? _selectedTaskStatus;

  double? _taskProgress = 0.0; // For Linear Progress Indicator

  // Variables to store date values
  DateTime? _startDate;
  DateTime? _endDate;

  // Controller for linear progress indicator
  final TextEditingController _taskProgressController =
      TextEditingController(text: '0.0');

  // Function selects the start date of leave
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      if (picked.isBefore(DateTime.now())) {
        // Show error dialog for start date before current date
        _showErrorDialog('Start date cannot be earlier than the current date');
      } else {
        setState(() {
          _startDate = picked;
          _startDateController.text = DateFormat('dd-MM-yyyy').format(picked);
          _endDate = null; // Reset end date when start date changes
          _endDateController.clear();
        });
      }
    }
  }

  // Function selects the end date of leave
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate == null ? _startDate : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && _startDate != null) {
      if (picked.isBefore(_startDate!)) {
        _showErrorDialog('End date cannot be earlier than the start date');
      } else {
        setState(() {
          _endDate = picked;
          _endDateController.text = DateFormat('dd-MM-yyyy').format(picked);
        });
      }
    }
  }

  @override
  void initState() {
    _titleController.text = task?.title ?? "";
    _descriptionController.text = task?.description ?? "";
    _createdDateController.text = TaskUiHelpers.formatDate(task?.createdAt);
    _taskAuthorController.text = task?.taskAuthor ?? "";
    _startDateController.text = TaskUiHelpers.formatDate(task?.startDate);
    _endDateController.text = TaskUiHelpers.formatDate(task?.endDate);
    _selectedTaskType = task?.taskType ?? TaskType.open;
    _assignedEmployeeController.text = task?.assignedEmployee ?? "";
    _selectedTaskStatus = task?.status ?? TaskStatus.todo;
    _taskProgressController.text = task?.taskProgress.toString() ?? "";
    _taskProgress = task?.taskProgress != null ? task!.taskProgress : null;
    super.initState();
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              Text('Error'),
            ],
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _createdDateController.dispose();
    _taskAuthorController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _assignedEmployeeController.dispose();
    _taskProgressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Task Title',
          ),
          onChanged: (value) {
            setState(() {
              _titleController.text = value;
            });
          },
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        TextFormField(
          controller: _descriptionController,
          minLines: 3,
          maxLines: null,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Task Description',
          ),
          onChanged: (value) {
            setState(() {
              _descriptionController.text = value;
            });
          },
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        TextFormField(
          readOnly: true,
          controller: _createdDateController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Task Created On',
          ),
        ),
        const SizedBox(height: 15.0),
        TextFormField(
          readOnly: true,
          controller: _taskAuthorController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Task Author',
          ),
        ),
        const SizedBox(height: 15.0),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _startDateController,
                readOnly: true,
                onTap: () async {
                  _selectStartDate(context);
                },
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_month),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Start Date is required';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: EchnoSize.defaultSpace / 2),
            Expanded(
              child: TextFormField(
                controller: _endDateController,
                readOnly: true,
                onTap: () async {
                  _selectEndDate(context);
                },
                decoration: const InputDecoration(
                  labelText: 'End Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_month),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        DropdownButtonFormField<TaskType>(
          value: _selectedTaskType,
          onChanged: (TaskType? newValue) {
            setState(() {
              _selectedTaskType = newValue;
            });
          },
          items: TaskType.values.map((TaskType taskType) {
            String typeName = TaskUiHelpers.getTaskTypeName(taskType);
            return DropdownMenuItem<TaskType>(
              value: taskType,
              child: Text(typeName),
            );
          }).toList(),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Task Type',
          ),
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        DropdownButtonFormField<TaskStatus>(
          value: _selectedTaskStatus,
          onChanged: (TaskStatus? newValue) {
            setState(() {
              _selectedTaskStatus = newValue;
            });
          },
          items: TaskStatus.values.map((TaskStatus taskStatus) {
            String statusName = TaskUiHelpers.getTaskStatusName(taskStatus);
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
        const SizedBox(height: 10.0),
        TextFormField(
          controller: _taskProgressController,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _taskProgress = double.tryParse(value) ?? 0.0;
            });
          },
          decoration: const InputDecoration(
            hintText: 'Task Progress (%)',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Task Progress is required';
            }
            double numericValue = double.tryParse(value) ?? -1;
            if (numericValue < 0 || numericValue > 100) {
              return 'Task Progress must be between 0 and 100';
            }
            return null;
          },
        ),
        const SizedBox(height: 10.0),
        Slider(
          value: double.tryParse(_taskProgressController.text) ?? 0.0,
          onChanged: (value) {
            setState(() {
              _taskProgress = value;
              _taskProgressController.text = value.toStringAsFixed(2);
            });
          },
          min: 0,
          max: 100,
          divisions: 100,
          label: _taskProgress?.round().toString(),
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        DropdownButtonFormField<String>(
          value: _assignedEmployeeController.text.isNotEmpty
              ? _assignedEmployeeController.text
              : null,
          onChanged: (String? value) {
            setState(() {
              _assignedEmployeeController.text = value ?? '';
            });
          },
          items: const [
            DropdownMenuItem<String>(
              value: null,
              child: Text('Select Employee'),
            ),
            DropdownMenuItem<String>(
              value: 'Employee 1',
              child: Text('Employee 1'),
            ),
            DropdownMenuItem<String>(
              value: 'Employee 2',
              child: Text('Employee 2'),
            ),
            DropdownMenuItem<String>(
              value: 'Employee 3',
              child: Text('Employee 3'),
            ),
          ],
          decoration: const InputDecoration(
            labelText: 'Assign Task',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final taskId = task?.id;
              final title = _titleController.text;
              final description = _descriptionController.text;
              final startDate = _startDate ??
                  DateFormat("dd-MM-yyyy").parse(_startDateController.text);
              final endDate = _endDate ??
                  DateFormat("dd-MM-yyyy").parse(_endDateController.text);
              final taskType = _selectedTaskType.toString().split('.').last;
              final taskStatus = _selectedTaskStatus.toString().split('.').last;
              final taskProgress = _taskProgress;
              final assignedEmployee = _assignedEmployeeController.text;

              try {
                await _taskService.updateTask(
                  taskId: taskId!,
                  newTitle: title,
                  newDescription: description,
                  newStartDate: startDate,
                  newEndDate: endDate,
                  newTaskType: taskType,
                  newTaskStatus: taskStatus,
                  newTaskProgress: taskProgress,
                  newAssignedEmployee: assignedEmployee,
                );
                if (context.mounted) {
                  EchnoSnackBar.successSnackBar(
                      context: context,
                      title: 'Success...!',
                      message: 'Task updated successfully.');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskHomeScreen(
                          index: TaskUiHelpers.getTaskHomeIndex(
                              _selectedTaskStatus.toString())),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  EchnoSnackBar.errorSnackBar(
                      context: context,
                      title: 'Oh Snap...!',
                      message: e.toString());
                }
              }
              // Clear the controllers after form submission
              setState(() {
                _titleController.clear();
                _descriptionController.clear();
                _startDateController.clear();
                _endDateController.clear();
                _assignedEmployeeController.clear();
              });
            },
            child: const Text('Update Task'),
          ),
        ),
      ],
    );
  }
}
