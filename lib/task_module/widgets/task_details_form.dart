import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/task_module/models/task_model.dart';
import 'package:flutter/material.dart';

class TaskDetailFormWidget extends StatelessWidget {
  const TaskDetailFormWidget({
    super.key,
    required TextEditingController titleController,
    required TextEditingController descriptionController,
    required TextEditingController createdDateController,
    required TextEditingController taskAuthorController,
    required TextEditingController startDateController,
    required TextEditingController endDateController,
    required TextEditingController taskTypeController,
    required TextEditingController statusController,
    required this.taskProgress,
    required this.task,
    required TextEditingController assignedEmployeeController,
  })  : _titleController = titleController,
        _descriptionController = descriptionController,
        _createdDateController = createdDateController,
        _taskAuthorController = taskAuthorController,
        _startDateController = startDateController,
        _endDateController = endDateController,
        _taskTypeController = taskTypeController,
        _statusController = statusController,
        _assignedEmployeeController = assignedEmployeeController;

  final TextEditingController _titleController;
  final TextEditingController _descriptionController;
  final TextEditingController _createdDateController;
  final TextEditingController _taskAuthorController;
  final TextEditingController _startDateController;
  final TextEditingController _endDateController;
  final TextEditingController _taskTypeController;
  final TextEditingController _statusController;
  final double? taskProgress;
  final Task? task;
  final TextEditingController _assignedEmployeeController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          readOnly: true,
          controller: _titleController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Task Title',
          ),
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        TextFormField(
          readOnly: true,
          controller: _descriptionController,
          minLines: 3,
          maxLines: null,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Task Description',
          ),
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
        const SizedBox(height: EchnoSize.spaceBtwItems),
        TextFormField(
          readOnly: true,
          controller: _taskAuthorController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Task Author',
          ),
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Start Date Date Picker
                  TextFormField(
                    controller: _startDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Start Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_month),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: EchnoSize.defaultSpace / 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // End Date Date Picker
                  TextFormField(
                    controller: _endDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'End Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_month),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        TextFormField(
          readOnly: true,
          controller: _taskTypeController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Task Type',
          ),
        ),
        const SizedBox(height: 15.0),
        TextFormField(
          readOnly: true,
          controller: _statusController,
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: taskProgress,
              ),
            ),
            const SizedBox(width: 4.0),
            Text(
              "${(task?.taskProgress)}% ",
              style: Theme.of(context).textTheme.titleMedium,
            )
          ],
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        TextFormField(
          readOnly: true,
          controller: _assignedEmployeeController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Assign Task',
          ),
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
      ],
    );
  }
}
