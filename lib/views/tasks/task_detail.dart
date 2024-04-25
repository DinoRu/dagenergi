import 'dart:io';
import 'package:dagenergi/controllers/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/tasks.dart';


class TaskDetailPage extends StatelessWidget {
  final MyTask task;
  const TaskDetailPage({super.key, required this.task});


  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(builder: (ctrl) {
      return GestureDetector(
        onTap:() => FocusScope.of(context).unfocus(),
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              title: Text(task.taskId!),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications)
                )
              ],
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
                          color: Colors.grey.withOpacity(0.3)
                      )
                    ]
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      taskContainer(num: task.code!, title: 'Код счетчика'),
                      const Divider(),
                      taskContainer(title: "Наименование", num: task.name!),
                      const Divider(),
                      taskContainer(title: "Исполнитель", num: task.implementer!),
                      const Divider(),
                      taskContainer(
                          num: task.currentIndication!.toString(),
                          title: 'Предыдущая показания'
                      ),
                      const Divider(),
                      Container(
                        height: 100,
                        margin: const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Текущий показание'),
                            const SizedBox(height: 10),
                            TextFormField(
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28
                              ),
                              onChanged: ctrl.updateIndication,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: '0'
                              ),
                              validator: (value) {
                                if(value == null || value.isEmpty) {
                                  return 'Введите цифру';
                                }
                                return null;
                              },

                            ),
                          ],
                        )
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: TextField(
                          controller: ctrl.commentCtrl,
                          maxLines: 10,
                          maxLength: 500,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'Пищите Комментарии',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.grey)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
                              )
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ctrl.file != null ? SizedBox(
                        height: 150,
                        width: double.maxFinite,
                        child: Image.file(File(ctrl.file!.path), fit: BoxFit.fill)
                      ): Container(),
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.maxFinite,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(Colors.black),
                          ),
                          onPressed:() async {
                            await ctrl.takeImage(task);
                          },
                          child: const Text('Сделать фото счетчика')
                        ),
                      ),
                      ctrl.hFile != null ? SizedBox(
                          height: 150,
                          width: double.maxFinite,
                          child: Image.file(File(ctrl.hFile!.path), fit: BoxFit.fill),
                      ): Container(),
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.maxFinite,
                        child: ElevatedButton(
                          style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black)),
                          onPressed: (){
                            ctrl.takeHomeImage(task);
                            },
                          child: const Text('Сделать дом фото'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.maxFinite,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors
                                  .blue),
                              foregroundColor: MaterialStateProperty.all(Colors
                                  .white)
                          ),
                          onPressed: () async {

                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Row(
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(width: 20,),
                                        Text('Envoi de la tache...')
                                      ],
                                    ),
                                  );
                                }
                              );
                              // ctrl.sendImageToServer(nearFile: ctrl.file!, homeFile: ctrl.hFile!);
                              await ctrl.uploadImageAndCompleteTask(task.taskId!, task.currentIndication!);
                              Navigator.pop(context);
                              // clear data
                              ctrl.commentCtrl.clear();
                              ctrl.setFile(null);
                              ctrl.setHFile(null);
                              Navigator.pop(context);
                          },
                          child: const Text('Отправьте'),
                        ),
                      ),
                    ]
                ),
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
            Text(num, style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),),
          ],
        )
    );
  }
}
