import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dagenergi/models/complete_task.dart';
import 'package:dagenergi/models/tasks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class TaskController extends GetxController {
  static TaskController get to => Get.find();

  //? TextEditingController
  TextEditingController commentCtrl = TextEditingController();
  TextEditingController searchItem = TextEditingController();
  final currentIndication = ''.obs;

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

  // compress file and get Uint8List

  //Using flutter_image_compress
  Future<XFile> _resizedImage(XFile imageFile) async {
    List<int> imageBytes = (await FlutterImageCompress.compressWithFile(
      imageFile.path,
      minHeight: 600,
      minWidth: 800,
      quality: 90,
    )) as List<int>;
    String fname = imageFile.name;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String compressImagePath = "$appDocPath/$fname.jpg";
    await File(compressImagePath).writeAsBytes(imageBytes);
    return XFile(compressImagePath);
  }

  //Function to take first image
  Future<void> takeImage(MyTask myTask) async {
    _file =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 90);
    update();
  }

  //Function to take second image
  Future<void> takeHomeImage(MyTask myTask) async {
    _hFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 90);
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

  @override
  void onClose() {
    super.onClose();
  }

  //Function to get all tasks
  Future<void> getAllTask({String? searchItem}) async {
    const apiUrl = "http://45.147.176.236:5000/tasks/";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        Utf8Decoder decoder = const Utf8Decoder();
        String decodeBody = decoder.convert(response.bodyBytes);
        final List<Map<String, dynamic>> responseData =
            List<Map<String, dynamic>>.from(
                json.decode(decodeBody)['result']['data']);
        //Filter task by search item
        final String? lowerSearchItem = searchItem?.toLowerCase();
        if (searchItem != null && searchItem.isNotEmpty) {
          tasks = responseData
              .map((json) => MyTask.fromJson(json))
              .where((task) =>
                  (task.code != null &&
                      task.code!.toLowerCase().contains(lowerSearchItem!)) ||
                  (task.name != null &&
                      task.name!.toLowerCase().contains(lowerSearchItem!)) ||
                  (task.address != null &&
                      task.address!.toLowerCase().contains(lowerSearchItem!)))
              .toList();
        } else {
          tasks = responseData.map((json) => MyTask.fromJson(json)).toList();
          totalTasks = tasks.length;
          print(totalTasks);
        }
      } else {
        throw Exception('Failed to fetch tasks');
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    } finally {
      update();
    }
  }

  //Function to update task
  Future<void> completeTask(String taskId, double previousIndication,
      String meterImageUrl, String homeImageUrl) async {
    final apiUrl = "http://45.147.176.236:5000/tasks/$taskId/complete";
    final completeTask = TaskComplete(
        nearPhotoUrl: meterImageUrl,
        farPhotoUrl: homeImageUrl,
        previousIndication: previousIndication,
        currentIndication: double.parse(currentIndication.value));
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
        Get.snackbar('Success', "Task was updated successufully!",
            colorText: Colors.green);
      } else {
        print(response.statusCode);
        Get.snackbar('Error', "Failed to update task", colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Failed', "Failed to update!", colorText: Colors.red);
      throw Exception("Failed to updated");
    }
  }

  Future<void> uploadImageAndCompleteTask(
      String taskId, double previousIndication) async {
    try {
      if (_file != null) {
        meterImageUrl = await uploadImage(_file!);
      }
      if (_hFile != null) {
        homeImageUrl = await uploadImage(_hFile!);
      }
      await completeTask(
          taskId, previousIndication, meterImageUrl, homeImageUrl);
      resetImages();
    } catch (e) {
      log(e.toString());
    }
  }
}
