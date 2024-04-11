import 'package:dagenergi/controllers/task_controller.dart';
import 'package:flutter/material.dart';

import '../../models/tasks.dart';

class TaskWidget extends StatelessWidget {
  final MyTask task;
  const TaskWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.code!),
      subtitle: Text(task.address!),
      // trailing: controller.isCompleted ? Text('Выполнил', style: TextStyle(color: Colors.green),) : Text('Не выполнил'),
    );
  }
}
