import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/services/hr_employee_service.dart';
import 'package:echno_attendance/employee/utilities/employee_role.dart';
import 'package:echno_attendance/site_module/models/site_model.dart';
import 'package:echno_attendance/task_module/services/task_service.dart';
import 'package:echno_attendance/task_module/utilities/task_status.dart';
import 'package:echno_attendance/task_module/utilities/task_types.dart';
import 'package:echno_attendance/task_module/utilities/task_ui_helpers.dart';
import 'package:echno_attendance/utilities/helpers/form_validators.dart';
import 'package:echno_attendance/utilities/popups/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTaskForm extends StatefulWidget {
  final SiteOffice siteOffice;
  const AddTaskForm({
    required this.siteOffice,
    super.key,
  });

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final _taskProvider = TaskService.firestoreTasks();

  // Variable for current date
  final DateTime _currentDate = DateTime.now();

  double _taskProgress = 0.0; // For Linear Progress Indicator

  // Controllers for text form fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _assignedEmployeeController =
      TextEditingController();

  List<Employee> members = [];
  late Employee assignedEmployee;
  bool isLoading = false;
  late TextEditingController controller;

  // Variables to control task progress update
  bool _isProgressEditable = true;
  double _progressEditedValue = 0.0;

  void _fetchEmployeeFromFirestore() async {
    setState(() {
      isLoading = true;
    });
    try {
      members = await HrEmployeeService.firestore()
          .populateMemberList(employeeIdList: widget.siteOffice.membersList);
    } catch (e) {
      EchnoSnackBar.errorSnackBar(
        context: context,
        title: 'Oh Snap...!',
        message: e.toString(),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchEmployeeFromFirestore();
  }

  // Variables to store dropdowns field values
  TaskType selectedTaskType = TaskType.open;
  TaskStatus? _selectedTaskStatus;

  // Variables to store date values
  DateTime? _startDate;
  DateTime? _endDate;

  // Controller for linear progress indicator
  final TextEditingController _taskProgressController =
      TextEditingController(text: '0.0');

  // Form key for validation
  final _addTaskFormKey = GlobalKey<FormState>();

  // Function selects the start date of leave
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
      initialDate: _startDate ?? DateTime.now(),
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
    _startDateController.dispose();
    _endDateController.dispose();
    _assignedEmployeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _addTaskFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Task Title',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 5.0),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Enter the task title...',
              border: OutlineInputBorder(),
            ),
            validator: (value) => EchnoValidator.defaultValidator(
              value,
              'Title is required',
            ),
          ),
          const SizedBox(height: EchnoSize.spaceBtwItems),
          Text(
            'Task Description',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 5.0),
          TextFormField(
            controller: _descriptionController,
            minLines: 3,
            maxLines: null, // Allows for an adjustable number of lines
            decoration: const InputDecoration(
              hintText: 'Enter task description...',
              border: OutlineInputBorder(),
            ),
            validator: (value) => EchnoValidator.defaultValidator(
              value,
              'Description is required',
            ),
          ),
          const SizedBox(height: EchnoSize.spaceBtwItems),
          Text(
            'Current Date',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 5.0),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              hintText: DateFormat('dd-MM-yyyy').format(_currentDate),
              hintStyle: Theme.of(context).textTheme.titleMedium,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: EchnoSize.spaceBtwItems),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Start Date',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 5.0),
                    // Start Date Date Picker
                    TextFormField(
                      controller: _startDateController,
                      readOnly: true,
                      onTap: () async {
                        _selectStartDate(context);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Start Date',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_month),
                      ),
                      validator: (value) => EchnoValidator.defaultValidator(
                        value,
                        'Start date is required',
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
                    Text(
                      'End Date',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 5.0),
                    // End Date Date Picker
                    TextFormField(
                      controller: _endDateController,
                      readOnly: true,
                      onTap: () async {
                        _selectEndDate(context);
                      },
                      decoration: const InputDecoration(
                        hintText: 'End Date',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_month),
                      ),
                      validator: (value) => EchnoValidator.defaultValidator(
                        value,
                        'End date is required',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: EchnoSize.spaceBtwItems),
          Text(
            'Assign Task',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 5.0),
          // Assigned Employee Dropdown
          Autocomplete<Employee>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable.empty();
              } else {
                return members.where((member) {
                  return member.employeeName
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()) ||
                      getEmloyeeRoleName(member.employeeRole)
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                }).toList();
              }
            },
            fieldViewBuilder:
                (context, controller, focusNode, onEdittingComplete) {
              this.controller = controller;
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                onEditingComplete: onEdittingComplete,
                decoration: InputDecoration(
                  hintText: 'Start typing',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.clear();
                    },
                  ),
                ),
              );
            },
            displayStringForOption: (Employee option) =>
                '${option.employeeName} (${option.employeeId})',
            onSelected: (Employee employee) {
              assignedEmployee = employee;
              _assignedEmployeeController.text = employee.employeeId;
            },
            optionsViewBuilder:
                (context, Function(Employee) onSelected, options) {
              return Material(
                child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: option.photoUrl != null
                              ? NetworkImage(option.photoUrl!)
                              : null,
                          child: option.photoUrl == null
                              ? const Icon(Icons.account_circle, size: 50)
                              : null,
                        ),
                        title: Text(option.employeeName),
                        subtitle: Text(getEmloyeeRoleName(option.employeeRole)),
                        onTap: () => onSelected(option),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: options.length),
              );
            },
          ),
          const SizedBox(height: EchnoSize.spaceBtwItems),
          Text(
            'Task Status',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 5.0),

          // Status Dropdown
          DropdownButtonFormField<TaskStatus>(
            value: _selectedTaskStatus,
            onChanged: (TaskStatus? newValue) {
              if (newValue == TaskStatus.upcoming) {
                setState(() {
                  _taskProgress = 0.0;
                  _taskProgressController.text = '0.0';
                  _isProgressEditable = false;
                });
              } else if (newValue == TaskStatus.completed) {
                setState(() {
                  _taskProgress = 100.0;
                  _taskProgressController.text = '100.0';
                  _isProgressEditable = false;
                });
              } else {
                setState(() {
                  _taskProgress = _progressEditedValue;
                  _taskProgressController.text =
                      _progressEditedValue.toStringAsFixed(2);
                  _isProgressEditable = true;
                });
              }
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
            ),
            validator: (value) => EchnoValidator.defaultValidator(
              value,
              'Task status is required',
            ),
          ),
          const SizedBox(height: EchnoSize.spaceBtwItems),
          Text(
            'Task Progress',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 5.0),
          // Task Progress Linear Progress Indicator
          TextFormField(
            enabled: _isProgressEditable,
            controller: _taskProgressController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _taskProgress = double.tryParse(value) ?? 0.0;
                _progressEditedValue = double.tryParse(value) ?? 0.0;
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
          const SizedBox(height: EchnoSize.spaceBtwItems),
          Slider(
            value: _taskProgress,
            onChanged: (value) {
              if (_selectedTaskStatus != TaskStatus.upcoming &&
                  _selectedTaskStatus != TaskStatus.completed) {
                setState(
                  () {
                    _taskProgress = value;
                    _taskProgressController.text = value.toStringAsFixed(2);
                    _progressEditedValue = value;
                  },
                );
              }
            },
            min: 0,
            max: 100,
            divisions: 100,
            label: _taskProgress.round().toString(),
          ),

          const SizedBox(height: EchnoSize.spaceBtwItems),
          // Button to submit leave application
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (_addTaskFormKey.currentState!.validate()) {
                  final title = _titleController.text;
                  final description = _descriptionController.text;
                  final createdAt = _currentDate;
                  final startDate = _startDate;
                  final endDate = _endDate;
                  const taskAuthor =
                      'Current Employee'; // From the currentEmployye function
                  final taskType = selectedTaskType.toString().split('.').last;
                  final taskStatus =
                      _selectedTaskStatus.toString().split('.').last;
                  final taskProgress = _taskProgress;
                  final assignedEmployee = _assignedEmployeeController.text;
                  final siteOffice = widget.siteOffice.siteOfficeName;
                  try {
                    await _taskProvider.addNewTask(
                      title: title,
                      description: description,
                      createdAt: createdAt,
                      startDate: startDate,
                      endDate: endDate,
                      taskAuthor: taskAuthor,
                      taskType: taskType,
                      taskStatus: taskStatus,
                      taskProgress: taskProgress,
                      assignedEmployee: assignedEmployee,
                      siteOffice: siteOffice,
                    );
                    if (context.mounted) {
                      EchnoSnackBar.successSnackBar(
                          context: context,
                          title: 'Success...!',
                          message: 'Task created successfully...');
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
                }
              },
              child: const Text('Create New Task'),
            ),
          ),
        ],
      ),
    );
  }
}
