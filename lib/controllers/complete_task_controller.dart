import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/tasks.dart';

class CompleteTaskController extends GetxController {
  TextEditingController searchCtrl = TextEditingController();

  List<MyTask> proccessTasks = [];
  List<MyTask> completeSearchResults = [];

  @override
  void onInit() async {
    await allProccessedTasks();
    super.onInit();
  }

  void searchInCompletedTasks(String query) {
    try {
      final String lowerQuery = query.toLowerCase();
      if (query.isEmpty) {
        completeSearchResults.assignAll(proccessTasks);
      } else {
        completeSearchResults = proccessTasks
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

  Future<void> allProccessedTasks() async {
    const apiUrl =
        'http://45.147.176.236:5000/tasks/?&order=ASC&condition=Проверяется';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        Utf8Decoder decoder = const Utf8Decoder();
        String decodeBody = decoder.convert(response.bodyBytes);
        final List<Map<String, dynamic>> responseData =
            List<Map<String, dynamic>>.from(
                json.decode(decodeBody)['result']['data']);
        proccessTasks =
            responseData.map((json) => MyTask.fromJson(json)).toList();
        completeSearchResults.assignAll(proccessTasks);
      } else {
        log("Don't fetch....");
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    } finally {
      update();
    }
  }
}
