// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

MyTask taskFromJson(String str) => MyTask.fromJson(json.decode(str));

String taskToJson(MyTask data) => json.encode(data.toJson());

class MyTask {
  String? taskId;
  String? code;
  String? name;
  String? address;
  double? currentIndication;
  double? previousIndication;
  String? implementer;
  double? latitude;
  double? longitude;
  String? comment;
  String? status;
  String? nearPhotoUrl;
  String? farPhotoUrl;
  DateTime? completionDate;
  dynamic deletedAt;

  MyTask({
    this.taskId,
    this.code,
    this.name,
    this.address,
    this.currentIndication,
    this.previousIndication,
    this.implementer,
    this.latitude,
    this.longitude,
    this.comment,
    this.status,
    this.nearPhotoUrl,
    this.farPhotoUrl,
    this.completionDate,
    this.deletedAt,
  });

  MyTask copyWith({
    String? taskId,
    String? code,
    String? name,
    String? address,
    double? currentIndication,
    double? previousIndication,
    String? implementer,
    double? latitude,
    double? longitude,
    String? comment,
    String? status,
    String? nearPhotoUrl,
    String? farPhotoUrl,
    DateTime? completionDate,
    dynamic deletedAt,
  }) =>
      MyTask(
        taskId: taskId ?? this.taskId,
        code: code ?? this.code,
        name: name ?? this.name,
        address: address ?? this.address,
        currentIndication: currentIndication ?? this.currentIndication,
        previousIndication: previousIndication ?? this.previousIndication,
        implementer: implementer ?? this.implementer,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        comment: comment ?? this.comment,
        status: status ?? this.status,
        nearPhotoUrl: nearPhotoUrl ?? this.nearPhotoUrl,
        farPhotoUrl: farPhotoUrl ?? this.farPhotoUrl,
        completionDate: completionDate ?? this.completionDate,
        deletedAt: deletedAt ?? this.deletedAt,
      );

  factory MyTask.fromJson(Map<String, dynamic> json) => MyTask(
    taskId: json["task_id"],
    code: json["code"],
    name: json["name"],
    address: json["address"],
    currentIndication: json["current_indication"],
    previousIndication: json["previous_indication"] !=null ? json['previous_indication'] : null,
    implementer: json["implementer"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    comment: json["comment"],
    status: json["status"],
    nearPhotoUrl: json["near_photo_url"],
    farPhotoUrl: json["far_photo_url"],
    completionDate: json["completion_date"] == null ? null : DateTime.parse(json["completion_date"]),
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
    "completion_date": completionDate?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
