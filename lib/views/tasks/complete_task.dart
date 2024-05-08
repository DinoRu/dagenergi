import 'package:dagenergi/controllers/complete_task_controller.dart';
import 'package:dagenergi/views/tasks/complete_task_detail.dart';
import 'package:dagenergi/views/tasks/task_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../custom_widgets/my_drawer.dart';

class CompleteTaskPage extends StatelessWidget {
  const CompleteTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompleteTaskController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: const Text('Завершенные задачи'),
          actions: [
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 25),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue[900],
              ),
              child: Center(child: Text('${ctrl.proccessTasks.length}')),
            ),
          ],

        ),
        drawer: const MyDrawer(),
        body:  Column(
          children: [
            Container(
              height: 50,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300]
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.search, color: Colors.grey,),
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextField(
                        controller: ctrl.searchCtrl,
                        onChanged: (value) {
                          ctrl.searchInCompletedTasks(ctrl.searchCtrl.text);
                        },
                        decoration:  const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Код, Наименование, Адрес счетчик",
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400

                            )
                        ),

                      )
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Scrollbar(
                  interactive: true,
                  child: ListView.builder(
                      itemExtent: 200,
                      itemCount: ctrl.searchCtrl.text.isEmpty ? ctrl.proccessTasks.length : ctrl.completeSearchResults.length,
                      itemBuilder: (context, i) {
                        final task = ctrl.searchCtrl.text.isEmpty ? ctrl.proccessTasks[i] : ctrl.completeSearchResults[i];
                        return InkWell(
                            onTap: () {
                              Get.to(() => CompleteTaskDetailPage(task: task));
                            },
                            child: TaskWidget(task: task)
                        );
                      }
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
