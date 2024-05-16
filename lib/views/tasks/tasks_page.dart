import 'package:dagenergi/controllers/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../custom_widgets/my_bottom_navigation_bar_item.dart';
import '../home/page_list.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(builder: (ctrl) {
      return Scaffold(
        body: page(ctrl.index),
        bottomNavigationBar: Container(
          height: 70,
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade100))),
          child: BottomNavigationBar(
              onTap: (int value) {
                ctrl.changeIndex(value);
              },
              currentIndex: ctrl.index,
              elevation: 1,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              items: [
                myBottomNavigationBarItem(
                    'В ы п о л н я е т с я', const Icon(Icons.donut_large)),
                myBottomNavigationBarItem(
                    'В ы п о л н е н о', const Icon(Icons.check))
              ]),
        ),
      );
    });
  }
}
