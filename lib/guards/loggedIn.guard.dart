import 'package:flutter/material.dart';
import 'package:FlashThread/data/secure_storage.dart';

loggedInGuard(context) async {
 String? token = await SecureStorage().readSecureData('token');

 if (token == null) {
   Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
 }
}