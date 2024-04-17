import 'package:echno_attendance/task_module/domain/firestore/firestore_task_handler.dart';
import 'package:echno_attendance/task_module/domain/firestore/task_handler.dart';
import 'package:echno_attendance/task_module/models/task_model.dart';
import 'package:echno_attendance/task_module/utilities/task_status.dart';

class TaskService implements TaskHandler {
  final TaskHandler _taskHandler;
  const TaskService(this._taskHandler);

  factory TaskService.firestoreTasks() {
    return TaskService(FirestoreTaskHandler());
  }

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
  }) {
    return _taskHandler.addNewTask(
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
  }) {
    return _taskHandler.updateTask(
      taskId: taskId,
      newTitle: newTitle,
      newDescription: newDescription,
      newStartDate: newStartDate,
      newEndDate: newEndDate,
      newTaskType: newTaskType,
      newTaskStatus: newTaskStatus,
      newTaskProgress: newTaskProgress,
      newAssignedEmployee: newAssignedEmployee,
      newSiteOffice: newSiteOffice,
    );
  }

  @override
  Future<void> updateTaskProgress({
    required String taskId,
    double? newTaskProgress,
    String? newTaskStatus,
  }) {
    return _taskHandler.updateTaskProgress(
      taskId: taskId,
      newTaskProgress: newTaskProgress,
      newTaskStatus: newTaskStatus,
    );
  }

  @override
  Future<void> deleteTask({required String taskId}) {
    return _taskHandler.deleteTask(taskId: taskId);
  }

  @override
  Stream<List<Task>> streamTasksByEmployee(
      {required String? assignedEmployee}) {
    return _taskHandler.streamTasksByEmployee(
        assignedEmployee: assignedEmployee);
  }

  @override
  Stream<List<Task>> streamTasksBySiteOffice({required String? siteOffice}) {
    return _taskHandler.streamTasksBySiteOffice(siteOffice: siteOffice);
  }

  @override
  Future<Map<TaskStatus, int>> getSiteTaskCounts({required String siteOffice}) {
    return _taskHandler.getSiteTaskCounts(siteOffice: siteOffice);
  }

  @override
  Future<Map<TaskStatus, int>> getEmployeeTaskCounts(
      {required String assignedEmployee}) {
    return _taskHandler.getEmployeeTaskCounts(
        assignedEmployee: assignedEmployee);
  }
}
