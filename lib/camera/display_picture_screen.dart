import 'dart:io';
import 'package:echno_attendance/common_widgets/loading_screen.dart';
import 'package:echno_attendance/employee/bloc/employee_bloc.dart';
import 'package:echno_attendance/employee/bloc/employee_event.dart';
import 'package:echno_attendance/employee/models/employee.dart';
import 'package:echno_attendance/employee/services/employee_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayPictureScreen extends StatefulWidget {
  final File imagePath;
  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  late final Employee currentEmployee;

  Future<void> fetchCurrentEmployee() async {
    final employee = await EmployeeService.firestore().currentEmployee;
    setState(() {
      currentEmployee = employee;
    });
  }

  Future<void> uploadImage(BuildContext ctx, File imageFile) async {
    try {
      final employeeid = currentEmployee.employeeId;
      DateTime attdate = DateTime.now();
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('attendance/$employeeid/$attdate');
      UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
      LoadingScreen().show(context: context, text: "Uploading Image");
      TaskSnapshot taskSnapshot = await uploadTask;
      String imgUrl = await taskSnapshot.ref.getDownloadURL();
      LoadingScreen().hide();
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Image Uploaded'),
                content: const Text('Your attendance has been marked'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () async {
                        ctx.read<EmployeeBloc>().add(MarkAttendanceEvent(
                              imageUrl: imgUrl,
                              isPictureTaken: true,
                              isPictureUploaded: true,
                            ));
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'))
                ],
              );
            });
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  @override
  void initState() {
    fetchCurrentEmployee();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Display the Picture',
          style: TextStyle(color: Colors.white),
        ),
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.black),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Image.file(widget.imagePath),
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await uploadImage(context, widget.imagePath);
                    },
                    child: const Text(
                      'Upload',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context
                          .read<EmployeeBloc>()
                          .add(const MarkAttendanceEvent(
                            isPictureTaken: false,
                            isPictureUploaded: false,
                          ));
                    },
                    child: const Text(
                      'Retake',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
        ],
      ),
    );
    return content;
  }
}
