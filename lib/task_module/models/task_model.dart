import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echno_attendance/task_module/utilities/task_status.dart';
import 'package:echno_attendance/task_module/utilities/task_types.dart';
import 'package:echno_attendance/task_module/utilities/task_ui_helpers.dart';
import 'package:echno_attendance/utilities/exceptions/firebase_exceptions.dart';
import 'package:echno_attendance/utilities/exceptions/platform_exceptions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

/// Represents a task with various attributes.
class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final String taskAuthor;
  final TaskType? taskType;
  final double taskProgress;
  final String? assignedEmployee;
  final String? siteOffice;
  final TaskStatus? status;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.startDate,
    this.endDate,
    required this.taskAuthor,
    this.taskType,
    required this.taskProgress,
    this.assignedEmployee,
    this.siteOffice,
    this.status,
  });

  /// Factory method to create a Task object from a Firestore QueryDocumentSnapshot.
  ///
  /// [doc] must not be null and must contain valid task data.
  /// Throws a specific exception if there's an error in data parsing.
  factory Task.fromSnapshot(QueryDocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>;
      return Task(
        id: doc.id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        createdAt: (data['created-at'] as Timestamp).toDate(),
        startDate: _parseTimestamp(data['start-date']),
        endDate: _parseTimestamp(data['end-date']),
        taskAuthor: data['task-author'] ?? '',
        taskType: TaskUiHelpers.getType(data['task-type']),
        status: TaskUiHelpers.getStatus(data['task-status']),
        taskProgress: (data['task-progress'] ?? 0.0).toDouble(),
        assignedEmployee: data['assigned-employee'] ?? '',
        siteOffice: data['site-office'] ?? '',
      );
    } on FirebaseException catch (e) {
      throw EchnoFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw EchnoPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong.! Please try again.';
    }
  }

  /// Internal method to parse a Firestore timestamp into a DateTime object.
  ///
  /// [timestamp] must be a valid Firestore Timestamp or null.
  /// Returns a DateTime object if parsing is successful, otherwise returns null.
  static DateTime? _parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    return null;
  }

  /// Specifies the properties used for equality comparison.
  @override
  List<Object?> get props => [
        createdAt,
        taskAuthor,
        taskType,
        assignedEmployee,
        siteOffice,
        status,
      ];

  /// Converts the Task object into a JSON-compatible map.
  ///
  /// Returns a map containing key-value pairs representing task properties.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'created-at': createdAt,
      'start-date': startDate,
      'end-date': endDate,
      'task-author': taskAuthor,
      'task-type': taskType?.toString().split('.').last,
      'task-status': status?.toString().split('.').last,
      'task-progress': taskProgress,
      'assigned-employee': assignedEmployee,
      'site-office': siteOffice,
    };
  }
}
