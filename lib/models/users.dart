// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  String userId;
  String username;
  String firstName;
  String lastName;
  String middleName;
  String department;
  String role;
  String password;

  Users({
    required this.userId,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.department,
    required this.role,
    required this.password,
  });

  Users copyWith({
    String? userId,
    String? username,
    String? firstName,
    String? lastName,
    String? middleName,
    String? department,
    String? role,
    String? password,
  }) =>
      Users(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        middleName: middleName ?? this.middleName,
        department: department ?? this.department,
        role: role ?? this.role,
        password: password ?? this.password,
      );

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    userId: json["user_id"],
    username: json["username"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    middleName: json["middle_name"],
    department: json["department"],
    role: json["role"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "username": username,
    "first_name": firstName,
    "last_name": lastName,
    "middle_name": middleName,
    "department": department,
    "role": role,
    "password": password,
  };
}
