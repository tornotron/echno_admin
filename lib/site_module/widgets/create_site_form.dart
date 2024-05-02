import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/site_module/bloc/site_bloc.dart';
import 'package:echno_attendance/site_module/widgets/employee_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:echno_attendance/attendance/services/location_service.dart';
import 'package:echno_attendance/site_module/utilities/site_status.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/site_module/services/site_service.dart';
import 'package:echno_attendance/utilities/helpers/form_validators.dart';
import 'package:echno_attendance/utilities/popups/custom_snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateSiteForm extends StatefulWidget {
  const CreateSiteForm({super.key});

  @override
  State<CreateSiteForm> createState() => _CreateSiteFormState();
}

class _CreateSiteFormState extends State<CreateSiteForm> {
  final TextEditingController _siteNameController = TextEditingController();
  final TextEditingController _siteAddressController = TextEditingController();
  final TextEditingController _siteLatitudeController = TextEditingController();
  final TextEditingController _siteLongitudeController =
      TextEditingController();
  final TextEditingController _siteRadiusController = TextEditingController();

  SiteStatus? _selectedSiteStatus;

  List<Employee> selectedEmployees = [];

  Employee? selectedProjectManager;

  Employee? selectedSupervisor;
  Employee? selectedSiteEngineer;
  Employee? selectedTechnicalCoordinator;

  List<String> firestoreEmployeeIdList = [];

  void _onSelectedEmployee(Employee employee) {
    if (!selectedEmployees.contains(employee)) {
      setState(() {
        selectedEmployees.add(employee);
        firestoreEmployeeIdList.add(employee.employeeId);
      });
    } else {
      EchnoSnackBar.warningSnackBar(
          context: context,
          title: 'Opps...!',
          message: 'Employee is already selected...');
    }
  }

  void _onSelectedProjectManager(Employee pm) {
    if (!selectedEmployees.contains(pm)) {
      setState(() {
        selectedEmployees.add(pm);
        selectedProjectManager = pm;
        firestoreEmployeeIdList.add(pm.employeeId);
      });
    } else {
      EchnoSnackBar.warningSnackBar(
          context: context,
          title: 'Opps...!',
          message: 'Project Manager already selected...');
    }
  }

  void _onSelectedSupervisor(Employee sp) {
    if (!selectedEmployees.contains(sp)) {
      setState(() {
        selectedEmployees.add(sp);
        selectedSupervisor = sp;
        firestoreEmployeeIdList.add(sp.employeeId);
      });
    } else {
      EchnoSnackBar.warningSnackBar(
          context: context,
          title: 'Opps...!',
          message: 'Supervisor already selected...');
    }
  }

  void _onSelectedSiteEngineer(Employee se) {
    if (!selectedEmployees.contains(se)) {
      setState(() {
        selectedEmployees.add(se);
        selectedSiteEngineer = se;
        firestoreEmployeeIdList.add(se.employeeId);
      });
    } else {
      EchnoSnackBar.warningSnackBar(
          context: context,
          title: 'Opps...!',
          message: 'Site Engineer already selected...');
    }
  }

  void _onSelectedTechnicalCoordinator(Employee tc) {
    if (!selectedEmployees.contains(tc)) {
      setState(() {
        selectedEmployees.add(tc);
        selectedTechnicalCoordinator = tc;
        firestoreEmployeeIdList.add(tc.employeeId);
      });
    } else {
      EchnoSnackBar.warningSnackBar(
          context: context,
          title: 'Opps...!',
          message: 'Technical Coordinator already selected...');
    }
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
    final employees = context.select((SiteBloc bloc) {
      return bloc.employees;
    });
    final supervisors = context.select((SiteBloc bloc) {
      return bloc.supervisors;
    });
    final siteEngineers = context.select((SiteBloc bloc) {
      return bloc.siteEngineers;
    });
    final technicalCoordinators = context.select((SiteBloc bloc) {
      return bloc.technicalCoordinators;
    });
    final projectManagers = context.select((SiteBloc bloc) {
      return bloc.projectManagers;
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          'Project Manager',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 5.0),
        EmployeeAutoComplete(
          employees: projectManagers,
          onSelectedEmployeesChanged: _onSelectedProjectManager,
          onPressSuffixIcon: () {
            selectedEmployees.remove(selectedProjectManager);
            firestoreEmployeeIdList.remove(selectedProjectManager!.employeeId);
            selectedProjectManager = null;
          },
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        Text(
          'Supervisor',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 5.0),
        EmployeeAutoComplete(
          employees: supervisors,
          onSelectedEmployeesChanged: _onSelectedSupervisor,
          onPressSuffixIcon: () {
            selectedEmployees.remove(selectedSupervisor);
            firestoreEmployeeIdList.remove(selectedSupervisor!.employeeId);
            selectedSupervisor = null;
          },
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        Text(
          'Site Engineer',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 5.0),
        EmployeeAutoComplete(
          employees: siteEngineers,
          onSelectedEmployeesChanged: _onSelectedSiteEngineer,
          onPressSuffixIcon: () {
            selectedEmployees.remove(selectedSiteEngineer);
            firestoreEmployeeIdList.remove(selectedSiteEngineer!.employeeId);
            selectedSiteEngineer = null;
          },
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        Text(
          'Technical Coordinator',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 5.0),
        EmployeeAutoComplete(
          employees: technicalCoordinators,
          onSelectedEmployeesChanged: _onSelectedTechnicalCoordinator,
          onPressSuffixIcon: () {
            selectedEmployees.remove(selectedTechnicalCoordinator);
            firestoreEmployeeIdList
                .remove(selectedTechnicalCoordinator!.employeeId);
            selectedTechnicalCoordinator = null;
          },
        ),
        const SizedBox(height: EchnoSize.spaceBtwItems),
        Text(
          'Add Members',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 5.0),
        EmployeeAutoComplete(
          employees: employees,
          onSelectedEmployeesChanged: _onSelectedEmployee,
        ),
        Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: 8.0,
                children: [
                  for (int index = 0; index < selectedEmployees.length; index++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Chip(
                        label: Text(selectedEmployees[index].employeeName),
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
                    validator: (value) => EchnoValidator.defaultValidator(
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
                    validator: (value) => EchnoValidator.defaultValidator(
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
                          Map<String, double> location =
                              await LocationService().getCurrentLocation();
                          _siteLatitudeController.text =
                              location['latitude'].toString();
                          _siteLongitudeController.text =
                              location['longitude'].toString();
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
              final siteStatus = _selectedSiteStatus.toString().split('.').last;
              final siteAddress = _siteAddressController.text;
              final siteLatitude = double.parse(_siteLatitudeController.text);
              final siteLongitude = double.parse(_siteLongitudeController.text);
              final siteRadius = double.parse(_siteRadiusController.text);
              final projectManager = selectedProjectManager?.employeeId ?? '';

              final siteSupervisor = selectedSupervisor?.employeeId ?? '';
              final siteEngineer = selectedSiteEngineer?.employeeId ?? '';
              final technicalCoordinator =
                  selectedTechnicalCoordinator?.employeeId ?? '';

              final memberList = firestoreEmployeeIdList;

              try {
                await SiteService.firestore().createSiteOffice(
                    siteName: siteName,
                    siteStatus: siteStatus,
                    siteAddress: siteAddress,
                    siteLatitude: siteLatitude,
                    siteLongitude: siteLongitude,
                    siteRadius: siteRadius,
                    projectManager: projectManager,
                    siteSupervisor: siteSupervisor,
                    siteEngineer: siteEngineer,
                    technicalCoordinator: technicalCoordinator,
                    memberList: memberList);
              } catch (e) {
                EchnoSnackBar.errorSnackBar(
                  context: context,
                  title: 'Oh Snap...!',
                  message: e.toString(),
                );
              } finally {
                EchnoSnackBar.successSnackBar(
                  context: context,
                  title: 'Success...!',
                  message: 'Site Created Successfully...',
                );
              }
            },
            child: const Text('Create Site'),
          ),
        ),
      ],
    );
  }
}
