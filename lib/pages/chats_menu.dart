import 'dart:convert';

import 'package:FlashThread/components/app_bars/chats_menu.appbar.dart';
import 'package:FlashThread/components/drawer.dart';
import 'package:FlashThread/data/secure_storage.dart';
import 'package:FlashThread/guards/loggedIn.guard.dart';
import 'package:FlashThread/models/ai_message.dart';
import 'package:FlashThread/models/ai_messages_data.dart';
import 'package:FlashThread/models/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_icon/gradient_icon.dart';
import 'package:http/http.dart' as http;
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ChatsMenuPage extends StatefulWidget {
  const ChatsMenuPage({super.key});

  @override
  State<StatefulWidget> createState() => _ChatsMenuPageState();
}

class _ChatsMenuPageState extends State<ChatsMenuPage> {
  String? userAvatarUrl;
  List<AiMessage> _messages = [];
  bool _loadedUserData = false;
  UserData _userData = const UserData(
    isMailVerify: false,
    avatar: 'http://',
    bio: 'loading...',
    email: 'loading...',
    id: '',
    l_name: 'loading...',
    name: 'loading...',
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    if (_scaffoldKey.currentState != null) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  @override
  void initState() {
    super.initState();
    loggedInGuard(context);
    Future<List<AiMessage>> fetchAiMessages() async {
      String token = await SecureStorage().readSecureData('token');

      final response = await http.post(
        Uri.parse('https://flashthread.adaptable.app/api/ai/chat/get'),
        body: {
          "token": token,
        },
      );

      if (response.statusCode == 201) {
        final jsonDataMap = jsonDecode(response.body) as Map<String, dynamic>;
        final jsonData = AiMessagesData.fromJson(jsonDataMap);

        List<AiMessage> messages = jsonData.messages.map((map) => AiMessage(
          message: map['message'],
          sender: map['sender'],
        )).toList();

        setState(() {
          print('hellollllllllllllllllllllllllllllllllllllllllllllll');
          _messages = messages;
        });

        return messages;
      } else {
        throw Exception('Failed to fetch AI messages');
      }
    }
    fetchAiMessages();
    Future<UserData> fetchUserData() async {
      String token = await SecureStorage().readSecureData('token');

      final response = await http.post(
          Uri.parse('https://flashthread.adaptable.app/api/get-user-by-token'),
          body: {
            "token": token,
          }
      );

      if (response.statusCode == 201) {
        final jsonDataMap = jsonDecode(response.body) as Map<String, dynamic>;
        final jsonData = UserData.fromJson(jsonDataMap);
        setState(() {
          _loadedUserData = true;
          _userData = jsonData;
        });
        return UserData.fromJson(jsonDataMap);
      } else {
        throw Exception('get user not successfully');
      }
    }
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromRGBO(38, 38, 38, 1),
      appBar: ChatsMenuAppBar(user: _userData, openDrawer: _openDrawer,),
      body: Container(
        padding: const EdgeInsets.only(
          top: 32,
          right: 25,
          bottom: 25,
          left: 25
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.only(
                bottom: 17
              ),
              child: const Text(
                'Chat',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 16,

                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/flash-ai');
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 3,
                            right: 10,
                            bottom: 18,
                            left: 10
                        ),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(31, 31, 31, 1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color.fromRGBO(162, 162, 162, 0.12),
                                width: 1
                            )
                        ),
                        child:  Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const GradientIcon(
                                icon: Icons.auto_awesome,
                                size: 40,
                                gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(255, 0, 251, 1),
                                      Color.fromRGBO(0, 58, 255, 1)
                                    ]
                                )
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 10,
                                  left: 20
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GradientText(
                                      'Flash Ai',
                                      style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold
                                      ),
                                      colors: const [
                                        Color.fromRGBO(255, 0, 251, 1),
                                        Color.fromRGBO(0, 58, 255, 1),
                                      ]
                                  ),
                                  Text(
                                    _messages.isNotEmpty ?
                                    _messages.last.message.length > 15 ?
                                    '${_messages.last.message.substring(0, 15)}...' : _messages.last.message : '',
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        color: Colors.white
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      drawer: DrawerComponent(user: _userData,),
    );
  }
}