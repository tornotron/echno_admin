import 'package:echno_attendance/task_module/models/task_model.dart';
import 'package:echno_attendance/task_module/utilities/task_status.dart';

abstract class TaskHandler {
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
  });

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
  });

  Future<void> updateTaskProgress({
    required String taskId,
    double? newTaskProgress,
    String? newTaskStatus,
  });

  Future<void> deleteTask({
    required String taskId,
  });

  Stream<List<Task>> streamTasksByEmployee({
    required String? assignedEmployee,
  });

  Stream<List<Task>> streamTasksBySiteOffice({
    required String? siteOffice,
  });

  Future<Map<TaskStatus, int>> getSiteTaskCounts({
    required String siteOffice,
  });

  Future<Map<TaskStatus, int>> getEmployeeTaskCounts({
    required String assignedEmployee,
  });
}
