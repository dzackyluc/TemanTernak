import 'dart:convert';

import 'package:flutter/foundation.dart';

class User {
  String? name;
  String? email;
  String? password;
  String? phone;
  String? username;

  User({this.name, this.email, this.password, this.phone, this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'],
        email: json['email'],
        password: json['password'],
        phone: json['phone'],
        username: json['username']);
  }

  String registertoJson() {
    return jsonEncode(<String, String>{
      'name': name!,
      'email': email!,
      'password': password!,
      'phone': phone!,
      'username': username!
    });
  }

  String logintoJson() {
    return jsonEncode(<String, String>{'email': email!, 'password': password!});
  }
}