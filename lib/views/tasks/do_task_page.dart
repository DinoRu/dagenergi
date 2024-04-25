import 'package:dagenergi/controllers/task_controller.dart';
import 'package:dagenergi/views/tasks/task_detail.dart';
import 'package:dagenergi/views/tasks/task_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../custom_widgets/my_drawer.dart';

class DoTaskPage extends StatelessWidget {
  const DoTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(builder: (ctrl) {
      return RefreshIndicator(
        onRefresh: () async {
          ctrl.getAllTask();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            title: const Text('Список задач'),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications)
              ),
            ],

          ),
          drawer: const MyDrawer(),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: CustomScrollView(
              slivers: [
                const SliverPadding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                ),
                SliverList.builder(
                  itemBuilder: (context, index) {
                    final task = ctrl.tasks[index];
                    return InkWell(
                        onTap: () {
                          Get.to(TaskDetailPage(task: task));
                        },
                        child: TaskWidget(task: task))
                    ;
                  },
                  itemCount: ctrl.tasks.length,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
