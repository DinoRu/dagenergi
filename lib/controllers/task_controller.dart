import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dagenergi/api/api.dart';
import 'package:dagenergi/models/complete_task.dart';
import 'package:dagenergi/models/tasks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class TaskController extends GetxController {
  static TaskController get to => Get.find();

  final taskUri = ApiUrl.getTaskUrl;

  //? TextEditingController
  TextEditingController commentCtrl = TextEditingController();
  TextEditingController searchItem = TextEditingController();
  TextEditingController searchCompletedTask = TextEditingController();
  final currentIndication = ''.obs;
  RxBool loading = false.obs;

  int totalTasks = 0;

  void updateIndication(String value) {
    currentIndication.value = value;
  }

  bool loadingImage = false;

  XFile? _file;
  XFile? _hFile;
  XFile? get hFile => _hFile;
  XFile? get file => _file;

  int index = 0;

  //Instance of image_picker
  final _picker = ImagePicker();

  //Variables
  bool isCompleted = false;
  String meterImageUrl = '';
  String homeImageUrl = '';

  List<MyTask> tasks = [];
  List<MyTask> searchResults = [];
  List<MyTask> cachedTasks = [];

  final Map<String, XFile?> tempTaskImage = {};

  void resetTaskImage(String taskId) {
    tempTaskImage[taskId] = null;
  }

  File? imageFile;

  void changeIndex(int value) {
    index = value;
    update();
  }

  //File setter
  void setFile(XFile? file) {
    _file = file;
    update();
  }

  void setHFile(XFile? hFile) {
    _hFile = hFile;
    update();
  }

  Future<void> showLocationPermissionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Permission request'),
            content: const Text(
                "'Для съемки фотографий этому приложению требуется разрешение на определение местоположения. Пожалуйста, предоставьте это разрешение в настройках."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Отменить")),
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await openAppSettings();
                  },
                  child: const Text('Откройте настройки')),
            ],
          );
        });
  }

  Future<bool> checkLocationPermission(BuildContext context) async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      status = await Permission.location.request();
    } else if (!status.isGranted) {
      await showLocationPermissionDialog(context);
    }
    return status.isGranted;
  }

  //Function to take first image
  Future<void> takeImage(MyTask myTask) async {
    _file =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 40);
    update();
  }

  //Function to take second image
  Future<void> takeHomeImage(MyTask myTask) async {
    _hFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 40);
    update();
  }

  //Function to upload image on Firebase Storage
  Future<String> uploadImage(XFile image) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String fileName = 'IMG_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = storage.ref('Images').child(fileName);

      UploadTask uploadTask = ref.putFile(File(image.path));
      TaskSnapshot taskSnapshot = await uploadTask;
      if (taskSnapshot.state == TaskState.success) {
        String downloadUrl = await ref.getDownloadURL();
        return downloadUrl;
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      throw Exception('Failed to upload image');
    }
  }

  void resetImages() {
    _file = null;
    _hFile = null;
  }

  @override
  void onInit() async {
    await getAllTask();
    super.onInit();
  }

  //Function to get all tasks
  Future<void> getAllTask() async {
    loading.value = true;
    try {
      final response = await http.get(Uri.parse(taskUri));
      if (response.statusCode == 200) {
        Utf8Decoder decoder = const Utf8Decoder();
        String decodeBody = decoder.convert(response.bodyBytes);
        final List<Map<String, dynamic>> responseData =
            List<Map<String, dynamic>>.from(
                json.decode(decodeBody)['result']['data']);
        tasks = responseData.map((json) => MyTask.fromJson(json)).toList();
        totalTasks = tasks.length;
        searchResults = List<MyTask>.from(tasks);
      } else {
        throw Exception('Failed to fetch tasks');
      }
    } catch (e) {
      rethrow;
    } finally {
      update();
      loading.value = false;
    }
  }

  //Search algorithm
  void searchTasks(String query) {
    try {
      final String lowerQuery = query.toLowerCase();
      if (query.isEmpty) {
        searchResults.assignAll(tasks);
      } else {
        searchResults = tasks
            .where((task) =>
                (task.name != null &&
                    task.name!.toLowerCase().contains(lowerQuery)) ||
                (task.address != null &&
                    task.address!.toLowerCase().contains(lowerQuery)) ||
                (task.number != null &&
                    task.number!.toLowerCase().contains(lowerQuery)))
            .toList();
      }
    } catch (e) {
      rethrow;
    } finally {
      update();
    }
  }

  //Function to update task
  Future<void> completeTask(String taskId, double previousIndication,
      String meterImageUrl, String homeImageUrl, String? comment) async {
    final apiUrl = "http://45.84.226.183:5000/tasks/$taskId/complete";
    final completeTask = TaskComplete(
      nearPhotoUrl: meterImageUrl,
      farPhotoUrl: homeImageUrl,
      previousIndication: previousIndication,
      currentIndication: double.parse(currentIndication.value),
      comment: comment,
    );
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: taskCompleteToJson(completeTask),
      );
      if (response.statusCode == 200) {
        tasks.removeWhere((task) => task.taskId == taskId);
        update();
        Get.snackbar("Успех", "Задание выполнено успешно!",
            colorText: Colors.white, backgroundColor: Colors.green.shade300);
      } else {
        Get.snackbar("Ошибка", "Не удалось выполнить задание",
            colorText: Colors.white, backgroundColor: Colors.red.shade300);
      }
    } catch (e) {
      Get.snackbar("Ошибка", "Не удалось выполнить задание",
          colorText: Colors.red, backgroundColor: Colors.white);
      throw Exception("Failed to updated");
    }
  }

  Future<void> uploadImageAndCompleteTask(
      String taskId, double previousIndication, String? comment) async {
    try {
      if (_file != null) {
        meterImageUrl = await uploadImage(_file!);
      }
      if (_hFile != null) {
        homeImageUrl = await uploadImage(_hFile!);
      }
      await completeTask(
          taskId, previousIndication, meterImageUrl, homeImageUrl, comment);
      resetImages();
    } catch (e) {
      log(e.toString());
    }
  }
}
