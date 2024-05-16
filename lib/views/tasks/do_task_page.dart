import 'package:dagenergi/controllers/task_controller.dart';
import 'package:dagenergi/utils/shimer_page.dart';
import 'package:dagenergi/views/tasks/task_detail.dart';
import 'package:dagenergi/views/tasks/task_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../custom_widgets/my_drawer.dart';

class DoTaskPage extends StatelessWidget {
  const DoTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(builder: (ctrl) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: RefreshIndicator(
          onRefresh: () async {
            ctrl.getAllTask();
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              title: const Text('Список задач'),
              actions: [
                Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 25),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue[900],
                  ),
                  child: Center(child: Text('${ctrl.tasks.length}')),
                ),
              ],
            ),
            drawer: const MyDrawer(),
            body: Column(
              children: [
                Container(
                  height: 50,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300]),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.search,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: TextField(
                        controller: ctrl.searchItem,
                        onChanged: (value) {
                          ctrl.searchTasks(ctrl.searchItem.text);
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Код, Наименование, Адрес счетчик",
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400)),
                      ))
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ctrl.loading.value
                        ? const TaskShimmerPage()
                        : Scrollbar(
                            interactive: true,
                            child: ListView.builder(
                                itemExtent: 200,
                                itemCount: ctrl.searchItem.text.isEmpty
                                    ? ctrl.tasks.length
                                    : ctrl.searchResults.length,
                                itemBuilder: (context, i) {
                                  final task = ctrl.searchItem.text.isEmpty
                                      ? ctrl.tasks[i]
                                      : ctrl.searchResults[i];
                                  return InkWell(
                                      onTap: () {
                                        Get.to(() => TaskDetailPage(
                                            task: task, ctrl: ctrl));
                                      },
                                      child: TaskWidget(task: task));
                                }),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
