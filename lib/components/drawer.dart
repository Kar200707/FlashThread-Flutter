import 'dart:convert';

import 'package:FlashThread/data/secure_storage.dart';
import 'package:FlashThread/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DrawerComponent extends StatefulWidget {
  final UserData user;

  const DrawerComponent({super.key, required this.user});

  @override
  State<DrawerComponent> createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          backgroundColor: const Color.fromRGBO(38, 38, 38, 1),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 150,
                    right: 40,
                    bottom: 20,
                    left: 20
                ),
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30)
                    )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.user.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(
                        textAlign: TextAlign.end,
                        widget.user.email,
                        style: const TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 0.47),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(
                        textAlign: TextAlign.end,
                        widget.user.bio,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                        ),
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 15,
                        right: 40,
                        bottom: 15,
                        left: 40
                    ),
                    margin: const EdgeInsets.only(
                        top: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(
                          child: Text(
                            textAlign: TextAlign.end,
                            'Profile',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 26
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 25
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 35,
                          ),
                        )
                      ],
                    ),
                  )
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 15,
                        right: 40,
                        bottom: 15,
                        left: 40
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(
                          child: Text(
                            textAlign: TextAlign.end,
                            'Settings',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 26
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 25
                          ),
                          child: const Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 35,
                          ),
                        )
                      ],
                    ),
                  )
              ),
              GestureDetector(
                  onTap: () {
                    SecureStorage().deleteSecureData('token');
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 15,
                      right: 40,
                      bottom: 15,
                      left: 40
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(
                          child: Text(
                            textAlign: TextAlign.end,
                            'Logout',
                            style: TextStyle(
                                color: Color.fromRGBO(244, 67, 54, 1),
                                fontFamily: 'Poppins',
                                fontSize: 26
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 25
                          ),
                          child: const Icon(
                            Icons.logout,
                            color: Color.fromRGBO(244, 67, 54, 1),
                            size: 35,
                          ),
                        )
                      ],
                    ),
                  )
              )
            ],
          )
      ),
    );
  }
}