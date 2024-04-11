import 'package:dagenergi/controllers/task_controller.dart';
import 'package:dagenergi/views/tasks/task_detail.dart';
import 'package:dagenergi/views/tasks/task_input.dart';
import 'package:dagenergi/views/tasks/task_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: Text('Список задач'),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications)
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: CustomScrollView(
            slivers: [
              const SliverPadding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
              ),
              SliverList.separated(
                itemBuilder: (context, index) {
                  final task = ctrl.tasks[index];
                  return InkWell(
                      onTap: () {
                        Get.to(TaskDetailPage(task: task));
                           // arguments: {'data': ctrl.tasks[index]});
                      },
                      child: TaskWidget(task: task))
                  ;
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: ctrl.tasks.length,
              ),
            ],
          ),
        ),
      );
    });
  }
}
