import 'package:cached_network_image/cached_network_image.dart';
import 'package:dagenergi/controllers/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/tasks.dart';

class CompleteTaskDetailPage extends StatelessWidget {
  final MyTask task;
  const CompleteTaskDetailPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(builder: (ctrl) {
      return GestureDetector(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            title: Text(task.name ?? 'N/A'),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(1, 1),
                        color: Colors.grey.withOpacity(0.3))
                  ]),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    taskContainer(num: task.number!, title: 'Код счетчика'),
                    Divider(
                      color: Colors.grey[300],
                    ),
                    taskContainer(
                        title: "Наименование", num: task.name ?? 'N/A'),
                    Divider(
                      color: Colors.grey[300],
                    ),
                    taskContainer(
                        title: "Исполнитель", num: task.implementer ?? 'N/A'),
                    Divider(
                      color: Colors.grey[300],
                    ),
                    taskContainer(
                        num: task.previousIndication.toString(),
                        title: 'Предыдущие показания'),
                    Divider(
                      color: Colors.grey[300],
                    ),
                    taskContainer(
                        num: task.currentIndication.toString(),
                        title: 'Текущие показания'),
                    Divider(
                      color: Colors.grey[300],
                    ),
                    task.comment != null
                        ? taskContainer(num: task.comment, title: "Комментарий")
                        : const Text(''),
                    Divider(
                      color: Colors.grey[300],
                    ),
                    const Text('Фото 1'),
                    SizedBox(
                      height: 250,
                      width: double.maxFinite,
                      child: CachedNetworkImage(
                        imageUrl: task.farPhotoUrl,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress)),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Divider(
                      color: Colors.grey[300],
                    ),
                    const Text('Фото 2'),
                    SizedBox(
                      height: 250,
                      width: double.maxFinite,
                      child: CachedNetworkImage(
                        imageUrl: task.nearPhotoUrl,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress)),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      );
    });
  }

  Widget taskContainer({String title = '', String num = ''}) {
    return Container(
        height: 60,
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                num,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ));
  }
}
