// To parse this JSON data, do
//
//     final myTask = myTaskFromJson(jsonString);

import 'dart:convert';

List<MyTask> myTaskFromJson(String str) => List<MyTask>.from(json.decode(str).map((x) => MyTask.fromJson(x)));

String myTaskToJson(List<MyTask> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyTask {
  String? taskId;
  String? code;
  String? name;
  String? address;
  dynamic currentIndication;
  double previousIndication;
  dynamic implementer;
  dynamic latitude;
  dynamic longitude;
  dynamic comment;
  String status;
  String? nearPhotoUrl;
  String? farPhotoUrl;
  dynamic completionDate;
  dynamic deletedAt;

  MyTask({
    required this.taskId,
    required this.code,
    required this.name,
    required this.address,
    required this.currentIndication,
    required this.previousIndication,
    required this.implementer,
    required this.latitude,
    required this.longitude,
    required this.comment,
    required this.status,
    required this.nearPhotoUrl,
    required this.farPhotoUrl,
    required this.completionDate,
    required this.deletedAt,
  });

  factory MyTask.fromJson(Map<String, dynamic> json) => MyTask(
    taskId: json["task_id"],
    code: json["code"],
    name: json["name"],
    address: json["address"],
    currentIndication: json["current_indication"],
    previousIndication: json["previous_indication"],
    implementer: json["implementer"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    comment: json["comment"],
    status: json["status"],
    nearPhotoUrl: json["near_photo_url"],
    farPhotoUrl: json["far_photo_url"],
    completionDate: json["completion_date"],
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "task_id": taskId,
    "code": code,
    "name": name,
    "address": address,
    "current_indication": currentIndication,
    "previous_indication": previousIndication,
    "implementer": implementer,
    "latitude": latitude,
    "longitude": longitude,
    "comment": comment,
    "status": status,
    "near_photo_url": nearPhotoUrl,
    "far_photo_url": farPhotoUrl,
    "completion_date": completionDate,
    "deleted_at": deletedAt,
  };
}
