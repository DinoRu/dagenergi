import 'package:flutter/material.dart';

import '../tasks/complete_task.dart';
import '../tasks/do_task_page.dart';

Widget page(int index) {

  List<Widget> pages = [
    const DoTaskPage(),
    const CompleteTaskPage()
  ];
  return pages[index];
}