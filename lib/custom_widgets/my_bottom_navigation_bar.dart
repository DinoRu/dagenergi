import 'package:dagenergi/controllers/task_controller.dart';
import 'package:dagenergi/custom_widgets/my_bottom_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.find<TaskController>();
    return Container(
     height: 70,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.2)
          )
        )
      ),
      child: BottomNavigationBar(
         onTap: (int value) {
          controller.changeIndex(value);
          },
          currentIndex: controller.index,
          elevation: 1,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            myBottomNavigationBarItem(
                'В ы п о л н я е т с я',
                const Icon(Icons.donut_large)
            ),
            myBottomNavigationBarItem(
                'В ы п о л н е н о',
                const Icon(Icons.check)
            )
          ]
      ),
    );
  }
}
