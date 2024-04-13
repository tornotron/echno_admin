import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echno_attendance/attendance/services/location_service.dart';
import 'package:echno_attendance/site_module/utilities/site_status.dart';
import 'package:echno_attendance/common_widgets/custom_app_bar.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/utilities/employee_role.dart';
import 'package:echno_attendance/site_module/services/site_service.dart';
import 'package:echno_attendance/utilities/helpers/form_validators.dart';
import 'package:echno_attendance/utilities/popups/custom_snackbar.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class CreateSiteScreen extends StatefulWidget {
  const CreateSiteScreen({super.key});

  @override
  State<CreateSiteScreen> createState() => _CreateSiteScreenState();
}

class _CreateSiteScreenState extends State<CreateSiteScreen> {
  // Controllers for text form fields
  final TextEditingController _siteNameController = TextEditingController();
  final TextEditingController _siteAddressController = TextEditingController();
  final TextEditingController _siteLatitudeController = TextEditingController();
  final TextEditingController _siteLongitudeController =
      TextEditingController();
  final TextEditingController _siteRadiusController = TextEditingController();

  SiteStatus? _selectedSiteStatus;

  List<Employee> employees = []; // List of users from Firestore
  List<Employee> selectedEmployees = [];
  List<String> firestoreEmployeeIdList = [];
  late TextEditingController controller;

  bool isLoading = false;

  void _fetchEmployeeFromFirestore() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('employees')
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        employees = snapshot.docs.map((doc) {
          return Employee.fromQueryDocumentSnapshot(doc);
        }).toList();
      });
    }).catchError((error) {
      {
        devtools.log("Failed to fetch employees: $error");
        return null;
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchEmployeeFromFirestore();
  }

  @override
  void dispose() {
    _siteNameController.dispose();
    _siteAddressController.dispose();
    _siteLatitudeController.dispose();
    _siteLongitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EchnoAppBar(
        leadingIcon: Icons.arrow_back_ios_new,
        leadingOnPressed: () {
          Navigator.pop(context);
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
                Text(
                  'Site Name',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  controller: _siteNameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Site Name...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => EchnoValidator.defaultValidator(
                    value,
                    'Site Name is required',
                  ),
                ),
                const SizedBox(height: EchnoSize.spaceBtwItems),
                Text(
                  'Site Address',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  controller: _siteAddressController,
                  minLines: 3,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Enter Site Address...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => EchnoValidator.defaultValidator(
                    value,
                    'Site Address is required',
                  ),
                ),
                const SizedBox(height: EchnoSize.spaceBtwItems),
                Text(
                  'Add Members',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 5.0),
                Autocomplete<Employee>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable.empty();
                    } else {
                      return employees.where((employee) {
                        return employee.employeeName.toLowerCase().contains(
                                textEditingValue.text.toLowerCase()) ||
                            getEmloyeeRoleName(employee.employeeRole)
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
                    if (!selectedEmployees.contains(employee)) {
                      setState(() {
                        selectedEmployees.add(employee);
                        firestoreEmployeeIdList.add(employee.employeeId);
                        controller.clear();
                      });
                    } else {
                      EchnoSnackBar.warningSnackBar(
                          context: context,
                          title: 'Opps...!',
                          message: 'Employee is already selected...');
                    }
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
                              subtitle:
                                  Text(getEmloyeeRoleName(option.employeeRole)),
                              onTap: () => onSelected(option),
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: options.length),
                    );
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing:
                            8.0, // Adjust the spacing between chips as needed
                        children: [
                          for (int index = 0;
                              index < selectedEmployees.length;
                              index++)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Chip(
                                label:
                                    Text(selectedEmployees[index].employeeName),
                                onDeleted: () {
                                  setState(() {
                                    selectedEmployees.removeAt(index);
                                    firestoreEmployeeIdList.removeAt(index);
                                  });
                                },
                                deleteIcon: const Icon(
                                  Icons.cancel,
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: EchnoSize.spaceBtwItems),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Location',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 5.0),
                          TextFormField(
                            controller: _siteLatitudeController,
                            decoration: const InputDecoration(
                              hintText: 'Enter Latitude...',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                EchnoValidator.defaultValidator(
                              value,
                              'Latitude is required',
                            ),
                          ),
                          const SizedBox(height: EchnoSize.spaceBtwItems),
                          TextFormField(
                            controller: _siteLongitudeController,
                            decoration: const InputDecoration(
                              hintText: 'Enter Longitude...',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                EchnoValidator.defaultValidator(
                              value,
                              'Longitude is required',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: EchnoSize.spaceBtwItems),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () async {
                                  await LocationService()
                                      .getCurrentLocation()
                                      .then(
                                    (location) {
                                      _siteLatitudeController.text =
                                          location.latitude.toString();
                                      _siteLongitudeController.text =
                                          location.longitude.toString();
                                    },
                                  );
                                },
                                child: const Text('Get Location')),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: EchnoSize.spaceBtwItems),
                Text(
                  'Radius',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  controller: _siteRadiusController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter Radius...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => EchnoValidator.defaultValidator(
                    value,
                    'Site Radius is required',
                  ),
                ),
                const SizedBox(height: EchnoSize.spaceBtwItems),
                Text(
                  'Site Status',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 5.0),
                DropdownButtonFormField<SiteStatus>(
                    value: _selectedSiteStatus,
                    onChanged: (SiteStatus? newValue) {
                      setState(() {
                        _selectedSiteStatus = newValue;
                      });
                    },
                    items: SiteStatus.values.map((SiteStatus status) {
                      String statusName = getSiteStatusName(status);
                      return DropdownMenuItem<SiteStatus>(
                        value: status,
                        child: Text(statusName),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      hintText: 'Select Site Status',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => EchnoValidator.defaultValidator(
                          value,
                          'Site Status is required',
                        )),
                const SizedBox(height: EchnoSize.spaceBtwItems),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final siteName = _siteNameController.text;
                      final siteStatus =
                          _selectedSiteStatus.toString().split('.').last;
                      final siteAddress = _siteAddressController.text;
                      final siteLatitude =
                          double.parse(_siteLatitudeController.text);
                      final siteLongitude =
                          double.parse(_siteLongitudeController.text);
                      final siteRadius =
                          double.parse(_siteRadiusController.text);
                      final memberList = firestoreEmployeeIdList;

                      await SiteService.firestore().createSiteOffice(
                          siteName: siteName,
                          siteStatus: siteStatus,
                          siteAddress: siteAddress,
                          siteLatitude: siteLatitude,
                          siteLongitude: siteLongitude,
                          siteRadius: siteRadius,
                          memberList: memberList);
                    },
                    child: const Text('Create Site'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
