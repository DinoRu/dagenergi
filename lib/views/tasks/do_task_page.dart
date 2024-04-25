import 'package:dagenergi/controllers/task_controller.dart';
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
                  SliverToBoxAdapter(
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey
                          )
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(CupertinoIcons.search, color: Colors.grey,),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: ctrl.searchItem,
                              onChanged: (value) {
                                ctrl.getAllTask(searchItem: ctrl.searchItem.text);
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Поиск(Код, наименование, адрес счетчик)',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 16
                                )
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
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
        ),
      );
    });
  }
}
