import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echno_attendance/logger.dart';
import 'package:echno_attendance/task_module/domain/firestore/task_handler.dart';
import 'package:echno_attendance/task_module/models/task_model.dart';
import 'package:echno_attendance/task_module/utilities/task_status.dart';
import 'package:echno_attendance/task_module/utilities/task_ui_helpers.dart';
import 'package:echno_attendance/utilities/exceptions/firebase_exceptions.dart';
import 'package:echno_attendance/utilities/exceptions/platform_exceptions.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class FirestoreTaskHandler implements TaskHandler {
  final logs = logger(FirestoreTaskHandler, Level.info);
  final CollectionReference _firestoreTasks =
      FirebaseFirestore.instance.collection('tasks');

  @override
  Future<Task?> addNewTask({
    required String title,
    required String description,
    required DateTime createdAt,
    required DateTime? startDate,
    required DateTime? endDate,
    required String taskAuthor,
    required String? taskType,
    required String? taskStatus,
    required double taskProgress,
    required String? assignedEmployee,
    required String? siteOffice,
  }) async {
    try {
      final taskDocument = await _firestoreTasks.add({
        'title': title,
        'description': description,
        'created-at': createdAt,
        'start-date': startDate != null ? Timestamp.fromDate(startDate) : null,
        'end-date': endDate != null ? Timestamp.fromDate(endDate) : null,
        'task-author': taskAuthor,
        'task-type': taskType,
        'task-status': taskStatus,
        'task-progress': taskProgress,
        'assigned-employee': assignedEmployee,
        'site-office': siteOffice,
      });

      logs.i('New task added..!');

      final fetchTask = await taskDocument.get();
      return Task(
        id: fetchTask.id,
        title: title,
        description: description,
        createdAt: createdAt,
        startDate: startDate,
        endDate: endDate,
        taskAuthor: taskAuthor,
        taskType: TaskUiHelpers.getType(taskType),
        status: TaskUiHelpers.getStatus(taskStatus),
        taskProgress: taskProgress,
        assignedEmployee: assignedEmployee,
        siteOffice: siteOffice,
      );
    } on FirebaseException catch (e) {
      throw EchnoFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw EchnoPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong.! Please try again.';
    }
  }

  @override
  Future<void> updateTask({
    required String taskId,
    String? newTitle,
    String? newDescription,
    DateTime? newStartDate,
    DateTime? newEndDate,
    String? newTaskType,
    String? newTaskStatus,
    double? newTaskProgress,
    String? newAssignedEmployee,
    String? newSiteOffice,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (newTitle != null) {
        updateData['title'] = newTitle;
      }

      if (newDescription != null) {
        updateData['description'] = newDescription;
      }

      if (newStartDate != null) {
        updateData['start-date'] = newStartDate;
      }

      if (newEndDate != null) {
        updateData['end-date'] = newEndDate;
      }

      if (newTaskType != null) {
        updateData['task-type'] = newTaskType;
      }

      if (newTaskStatus != null) {
        updateData['task-status'] = newTaskStatus;
      }

      if (newTaskProgress != null) {
        updateData['task-progress'] = newTaskProgress;
      }

      if (newAssignedEmployee != null) {
        updateData['assigned-employee'] = newAssignedEmployee;
      }

      if (newSiteOffice != null) {
        updateData['site-office'] = newSiteOffice;
      }

      await _firestoreTasks
          .doc(taskId)
          .set(updateData, SetOptions(merge: true));
      logs.i('Task details updated..!');
    } on FirebaseException catch (e) {
      throw EchnoFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw EchnoPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong.! Please try again.';
    }
  }

  @override
  Future<void> updateTaskProgress({
    required String taskId,
    double? newTaskProgress,
    String? newTaskStatus,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (newTaskStatus != null) {
        updateData['task-status'] = newTaskStatus;
      }

      if (newTaskProgress != null) {
        updateData['task-progress'] = newTaskProgress;
      }
      await _firestoreTasks.doc(taskId).update(updateData);
      logs.i('task status updated..!');
    } on FirebaseException catch (e) {
      throw EchnoFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw EchnoPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong.! Please try again.';
    }
  }

  @override
  Future<void> deleteTask({required String taskId}) async {
    try {
      await _firestoreTasks.doc(taskId).delete();
      logs.i('task deleted..!');
    } on FirebaseException catch (e) {
      throw EchnoFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw EchnoPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong.! Please try again.';
    }
  }

  @override
  Stream<List<Task>> streamTasksByEmployee(
      {required String? assignedEmployee}) {
    try {
      return _firestoreTasks
          .where('assigned-employee', isEqualTo: assignedEmployee)
          .snapshots()
          .map((QuerySnapshot<Object?> querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return Task.fromSnapshot(
              doc as QueryDocumentSnapshot<Map<String, dynamic>>);
        }).toList();
      });
    } on FirebaseException catch (e) {
      throw EchnoFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw EchnoPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong.! Please try again.';
    }
  }

  @override
  Stream<List<Task>> streamTasksBySiteOffice({required String? siteOffice}) {
    try {
      return _firestoreTasks
          .where('site-office', isEqualTo: siteOffice)
          .snapshots()
          .map((QuerySnapshot<Object?> querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return Task.fromSnapshot(
              doc as QueryDocumentSnapshot<Map<String, dynamic>>);
        }).toList();
      });
    } on FirebaseException catch (e) {
      throw EchnoFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw EchnoPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong.! Please try again.';
    }
  }

  @override
  Future<Map<TaskStatus, int>> getSiteTaskCounts(
      {required String siteOffice}) async {
    try {
      final tasks = await _firestoreTasks
          .where('site-office', isEqualTo: siteOffice)
          .snapshots()
          .map((QuerySnapshot<Object?> querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return Task.fromSnapshot(
              doc as QueryDocumentSnapshot<Map<String, dynamic>>);
        }).toList();
      }).first;

      final taskCounts = {
        TaskStatus.onHold:
            tasks.where((task) => task.status == TaskStatus.onHold).length,
        TaskStatus.completed:
            tasks.where((task) => task.status == TaskStatus.completed).length,
        TaskStatus.inProgress:
            tasks.where((task) => task.status == TaskStatus.inProgress).length,
        TaskStatus.todo:
            tasks.where((task) => task.status == TaskStatus.todo).length,
      };
      return taskCounts;
    } on FirebaseException catch (e) {
      throw EchnoFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw EchnoPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong.! Please try again.';
    }
  }
}
