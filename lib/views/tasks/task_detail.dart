import 'dart:io';
import 'package:dagenergi/controllers/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/tasks.dart';

class TaskDetailPage extends StatelessWidget {
  final MyTask task;
  final TaskController ctrl;
  const TaskDetailPage({super.key, required this.task, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
        dispose: (_) => TaskController.to.resetImages(),
        builder: (ctrl) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
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
                            title: "Исполнитель",
                            num: task.implementer ?? 'N/A'),
                        Divider(
                          color: Colors.grey[300],
                        ),
                        taskContainer(
                            num: task.previousIndication.toString(),
                            title: 'Предыдущие показания'),
                        Divider(
                          color: Colors.grey[300],
                        ),
                        Container(
                            height: 100,
                            margin: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Текущие показания'),
                                const SizedBox(height: 10),
                                TextFormField(
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28),
                                  onChanged: ctrl.updateIndication,
                                  keyboardType: TextInputType.number,
                                  decoration:
                                      const InputDecoration(hintText: '0'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Введите текущие показания';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            )),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: ctrl.commentCtrl,
                            maxLines: 10,
                            maxLength: 500,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: 'Комментарий',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary))),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ctrl.file != null
                            ? SizedBox(
                                height: 200,
                                width: double.maxFinite,
                                child: Image.file(File(ctrl.file!.path),
                                    fit: BoxFit.cover))
                            : const SizedBox(),
                        Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.maxFinite,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.black),
                              ),
                              onPressed: () async {
                                if (await ctrl
                                    .checkLocationPermission(context)) {
                                  await ctrl.takeImage(task);
                                }
                              },
                              child: const Text('Фото показаний')),
                        ),
                        ctrl.hFile != null
                            ? SizedBox(
                                height: 200,
                                width: double.maxFinite,
                                child: Image.file(File(ctrl.hFile!.path),
                                    fit: BoxFit.cover),
                              )
                            : const SizedBox(),
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.maxFinite,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.black)),
                            onPressed: () async {
                              if (await ctrl.checkLocationPermission(context)) {
                                ctrl.takeHomeImage(task);
                              }
                            },
                            child: const Text('Фото счётчика'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.maxFinite,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(Colors.blue),
                                foregroundColor:
                                    WidgetStateProperty.all(Colors.white)),
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return const AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Center(child: Text('Загрузка...'))
                                        ],
                                      ),
                                    );
                                  });
                              // ctrl.sendImageToServer(nearFile: ctrl.file!, homeFile: ctrl.hFile!);
                              await ctrl.uploadImageAndCompleteTask(
                                  task.taskId!,
                                  task.previousIndication!,
                                  ctrl.commentCtrl.text);

                              Navigator.pop(context);
                              // clear data
                              ctrl.commentCtrl.clear();
                              ctrl.setFile(null);
                              ctrl.setHFile(null);
                              Navigator.pop(context);
                            },
                            child: const Text('Выполнить'),
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
