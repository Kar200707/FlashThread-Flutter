import 'package:flutter/material.dart';
import 'package:FlashThread/data/secure_storage.dart';

authGuard(context) async {
  String? token = await SecureStorage().readSecureData('token');

  if (token != null) {
    Navigator.of(context).pushNamedAndRemoveUntil('/chats-menu', (Route<dynamic> route) => false);
  }
  return token != null;
}