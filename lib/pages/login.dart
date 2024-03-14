import 'dart:convert';

import 'package:FlashThread/data/secure_storage.dart';
import 'package:FlashThread/guards/auth.guard.dart';
import 'package:FlashThread/models/login_return_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isFalseAuth = false;

  Future<void> startLoading() async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const SimpleDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        );
      },
    );
  }

  Future<void> stopLoading() async {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    authGuard(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Container(
          margin: const EdgeInsets.only(top: 20),
          child: Image.asset('assets/images/side-icons/flash-thread-colors.png', scale: 2),
        )
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 100),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GradientText('Login',
                    colors: const [
                      Color.fromRGBO(255, 0, 251, 1),
                      Color.fromRGBO(0, 58, 255, 1),
                    ],
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: TextField(
                      onChanged: (content) {
                        setState(() {
                          isFalseAuth = false;
                        });
                      },
                      controller: emailController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            top: 16,
                            right: 20,
                            bottom: 16,
                            left: 20
                        ),
                        hintText: 'Enter Your email',
                        hintStyle: const TextStyle(
                          color: Color.fromRGBO(92, 19, 164, .6),
                          fontSize: 20,
                          fontFamily: 'Poppins',
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                width: 3,
                                color: Color.fromRGBO(92, 19, 164, 1)
                            )
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                width: 3,
                                color: Color.fromRGBO(92, 19, 164, 1)
                            )
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: TextField(
                      onChanged: (content) {
                        setState(() {
                          isFalseAuth = false;
                        });
                      },
                      controller: passwordController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                      ),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            top: 16,
                            right: 20,
                            bottom: 16,
                            left: 20
                        ),
                        hintText: 'Enter Your password',
                        hintStyle: const TextStyle(
                          color: Color.fromRGBO(92, 19, 164, .6),
                          fontSize: 20,
                          fontFamily: 'Poppins',
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                width: 3,
                                color: Color.fromRGBO(92, 19, 164, 1)
                            )
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                width: 3,
                                color: Color.fromRGBO(92, 19, 164, 1)
                            )
                        ),
                      ),
                    ),
                  ),
                  if (isFalseAuth) Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 5),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Incorrect email or password',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color.fromRGBO(210, 59, 59, 1),
                          ),
                        ),
                      ],
                    )
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    child: SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                  colors: [
                                    Color.fromRGBO(153, 0, 255, 1),
                                    Color.fromRGBO(115, 0, 255, 1),
                                  ]
                              )
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              startLoading();
                              Future<LoginReturnData> fetchLogin() async {

                                final response = await http.post(
                                  Uri.parse('https://flashthread.adaptable.app/api/login'),
                                  body: {
                                    "email": emailController.text,
                                    "password": passwordController.text
                                  }
                                );

                                if (response.statusCode == 201) {
                                  stopLoading();
                                  final jsonDataMap = jsonDecode(response.body) as Map<String, dynamic>;
                                  final jsonData = LoginReturnData.fromJson(jsonDataMap);

                                  SecureStorage().writeSecureData('token', jsonData.access_token);
                                  Navigator.of(context).pushNamedAndRemoveUntil('/chats-menu', (Route<dynamic> route) => false);
                                  setState(() {
                                    isFalseAuth = false;
                                  });
                                  return LoginReturnData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
                                } else {
                                  stopLoading();
                                  setState(() {
                                    isFalseAuth = true;
                                  });
                                  throw Exception('Auth not successfully');
                                }
                              }
                              fetchLogin();

                              emailController.clear();
                              passwordController.clear();
                            },
                            style: ElevatedButton.styleFrom(
                                shadowColor: Colors.transparent,
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.only(top: 8, bottom: 8)
                            ),
                            child: const Text(
                              'SEND',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 22,
                                  letterSpacing: 2
                              ),
                            ),
                          ),
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/register', ModalRoute.withName('/'));
                    },
                    child: GradientText(
                      "don't have an account? - register",
                      style: const TextStyle(
                          fontSize: 16
                      ),
                      colors: const [
                        Color.fromRGBO(39, 68, 166, 1),
                        Color.fromRGBO(154, 26, 152, 1),
                      ],
                    ),
                  ),
                ],
              )
          ),
        ),
      )
    );
  }
  
}