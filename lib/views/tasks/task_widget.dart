import 'package:dagenergi/controllers/task_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/tasks.dart';

class TaskWidget extends StatelessWidget {
  final MyTask task;
  const TaskWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.shade300
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            task.code!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: Text(
              task.name!,
              style: const TextStyle(
                fontSize: 16
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
              task.address!,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}
