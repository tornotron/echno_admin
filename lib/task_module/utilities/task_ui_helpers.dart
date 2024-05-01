import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/task_module/utilities/task_status.dart';
import 'package:echno_attendance/task_module/utilities/task_types.dart';

/// Helper class providing utility methods related to UI representation of tasks.
class TaskUiHelpers {
  /// Returns the background color for a task tile based on its status and type.
  ///
  /// [status] represents the status of the task.
  /// [type] represents the type of the task.
  /// Returns a color representing the background color for the task tile.
  static getTaskTileBGClr(TaskStatus? status, TaskType? type) {
    if (type == TaskType.disposed) {
      return EchnoColors.taskDisposed;
    }
    switch (status) {
      case TaskStatus.upcoming:
        return EchnoColors.taskUpcoming;
      case TaskStatus.onGoing:
        return EchnoColors.taskOngoing;
      case TaskStatus.onHold:
        return EchnoColors.taskOnhold;
      case TaskStatus.completed:
        return EchnoColors.taskCompleted;

      default:
        return EchnoColors.taskUpcoming;
    }
  }

  /// Returns the custom status name [String] for a task tile based on its status.
  ///
  /// [status] represents the status of the task.
  /// Returns a custom name which will be a string representing the status for the task tile.
  static String getTaskTileStatusString(TaskStatus? status) {
    switch (status) {
      case TaskStatus.upcoming:
        return 'UPCOMING';
      case TaskStatus.onGoing:
        return 'ON GOING';
      case TaskStatus.onHold:
        return 'ON HOLD';
      case TaskStatus.completed:
        return 'COMPLETED';
      default:
        return 'TODO';
    }
  }

  /// Returns the name of the task status based on its status.
  ///
  /// [status] represents the status of the task.
  /// Returns a custom name string representing the name of the task status.
  static String getTaskStatusName(TaskStatus? status) {
    switch (status) {
      case TaskStatus.upcoming:
        return 'Upcoming';
      case TaskStatus.onGoing:
        return 'On Going';
      case TaskStatus.onHold:
        return 'On Hold';
      case TaskStatus.completed:
        return 'Completed';
      default:
        return 'TODO';
    }
  }

  /// Returns the type string for a task tile based on its type.
  ///
  /// [taskType] represents the type of the task.
  /// Returns a custom name string for representing the type for the task tile.
  static String getTaskTileTypeString(TaskType? taskType) {
    switch (taskType) {
      case TaskType.open:
        return 'OPEN';
      case TaskType.disposed:
        return 'DISPOSED';
      case TaskType.closed:
        return 'CLOSED';
      default:
        return 'OPEN';
    }
  }

  static String getTaskTypeName(TaskType? taskType) {
    switch (taskType) {
      case TaskType.open:
        return 'Open';
      case TaskType.closed:
        return 'Closed';
      case TaskType.disposed:
        return 'Disposed';
      default:
        return 'Open';
    }
  }

  /// Formats a given [date] into a string.
  ///
  /// [date] represents the date to be formatted.
  /// Returns a formatted string representation of the date.
  static String formatDate(DateTime? date) {
    if (date == null) {
      return ""; // Handle null date case
    }
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  /// Returns the index of the selected task category for the home screen.
  ///
  /// [selectedStatus] represents the selected status for the task category.
  /// Returns the index corresponding to the selected status for the task category.
  static int getTaskHomeIndex(String selectedStatus) {
    switch (selectedStatus) {
      case 'onHold':
        return 0;
      case 'onGoing':
        return 1;
      case 'upcoming':
        return 2;
      case 'completed':
        return 3;

      default:
        return 1;
    }
  }

  /// Returns the TaskStatus enum value corresponding to the selected index.
  ///
  /// [selectedIndex] represents the selected index for the task category.
  /// Returns the TaskStatus enum value corresponding to the selected index.
  static TaskStatus getSelectedCategory(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return TaskStatus.onHold;
      case 1:
        return TaskStatus.onGoing;
      case 2:
        return TaskStatus.upcoming;
      case 3:
        return TaskStatus.completed;

      default:
        return TaskStatus.upcoming;
    }
  }

  /// Converts a string representation of status to a TaskStatus enum.
  ///
  /// [status] represents the string representation of the task status.
  /// Returns the TaskStatus enum value corresponding to the input string.
  static TaskStatus getStatus(String? status) {
    switch (status) {
      case 'upcoming':
        return TaskStatus.upcoming;
      case 'onGoing':
        return TaskStatus.onGoing;
      case 'onHold':
        return TaskStatus.onHold;
      case 'completed':
        return TaskStatus.completed;
      default:
        return TaskStatus.upcoming;
    }
  }

  /// Converts a string representation of task type to a TaskType enum.
  ///
  /// [taskType] represents the string representation of the task type.
  /// Returns the TaskType enum value corresponding to the input string.
  static TaskType getType(String? taskType) {
    switch (taskType) {
      case 'open':
        return TaskType.open;
      case 'closed':
        return TaskType.closed;
      case 'disposed':
        return TaskType.disposed;
      default:
        return TaskType.closed;
    }
  }
}
