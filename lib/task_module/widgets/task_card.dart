import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/task_module/models/task_model.dart';
import 'package:echno_attendance/task_module/utilities/task_types.dart';
import 'package:echno_attendance/task_module/utilities/task_ui_helpers.dart';
import 'package:echno_attendance/utilities/helpers/device_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskCard extends StatelessWidget {
  final Task? task;

  const TaskCard(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    final double taskProgress = task!.taskProgress / 100;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color:
                  TaskUiHelpers.getTaskTileBGClr(task?.status, task?.taskType),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task?.title ?? "",
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: EchnoColors.white),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            color: EchnoColors.taskIcon,
                            size: 18,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            "${TaskUiHelpers.formatDate(task?.startDate)} - ${TaskUiHelpers.formatDate(task?.endDate)}",
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 13.0,
                                color: EchnoColors.taskText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person_2_rounded,
                            color: EchnoColors.taskIcon,
                            size: 18.0,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            "${task?.assignedEmployee} ",
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 13.0,
                                color: EchnoColors.taskText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: taskProgress,
                              color: EchnoColors.taskIcon,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  EchnoColors.taskText),
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            "${(task?.taskProgress)}% ",
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  fontSize: 13.0, color: EchnoColors.taskText),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        task?.description ?? "",
                        maxLines: 1,
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            fontSize: 15.0,
                            color: EchnoColors.taskText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  height: 60.0,
                  width: 1.0,
                  color: EchnoColors.taskIcon.withOpacity(0.7),
                ),
                RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    task?.taskType == TaskType.open ||
                            task?.taskType == TaskType.closed
                        ? TaskUiHelpers.getTaskTileStatusString(task?.status)
                        : TaskUiHelpers.getTaskTileTypeString(task?.taskType),
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          letterSpacing: 1.8,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: EchnoColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (task?.taskType == TaskType.closed)
            Positioned(
              top: 0,
              right: 0,
              child: SizedBox(
                width: DeviceUtilityHelpers.getScreenWidth(context),
                child: const Banner(
                  color: EchnoColors.taskBanner,
                  message: 'CLOSED',
                  location: BannerLocation.topEnd,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
