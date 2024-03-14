import 'dart:async';
import 'dart:convert';

import 'package:FlashThread/components/app_bars/flash_ai.appbar.dart';
import 'package:FlashThread/data/secure_storage.dart';
import 'package:FlashThread/models/ai_data.dart';
import 'package:FlashThread/models/ai_message.dart';
import 'package:FlashThread/models/ai_messages_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class FlashAiPage extends StatefulWidget {
  const FlashAiPage({super.key});

  @override
  State<StatefulWidget> createState() => FlashAiPageState();
}

class FlashAiPageState extends State<FlashAiPage> {
  List<AiMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _sendTextController = TextEditingController();
  bool aiGenerating = false;
  AudioPlayer audio = AudioPlayer();
  bool _textFiledIsNotEmpty = false;
  final List<dynamic> _history = [];

  _playNotifyAudio() async {
    await audio.setAsset('assets/audios/tones.mp3');
    await audio.play();
  }

  _playSendAudio() async {
    await audio.setAsset('assets/audios/send-tone.mp3');
    await audio.play();
  }

  fetchAiMessages() async {
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
        _messages = messages.reversed.toList();
      });

      return messages;
    } else {
      throw Exception('Failed to fetch AI messages');
    }
  }

  @override
  void initState() {
    super.initState();

    fetchAiMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(30, 30, 30, 1),
      appBar: FlashAiAppBar(callback: fetchAiMessages,),
      body: Container(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.only(
            bottom: 30
          ),
          itemCount: _messages.length,
          reverse: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int i) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      top: 18
                  ),
                  child: Column(
                    crossAxisAlignment:
                    _messages[i].sender != 'user' ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                    children: [
                      if (_messages[i].sender != 'user') const Icon(
                        Icons.auto_awesome,
                        size: 24,
                        color: Colors.white,
                      ),
                      Container(
                          margin: const EdgeInsets.only(
                              top: 10
                          ),
                          padding: const EdgeInsets.only(
                              top: 10,
                              right: 15,
                              bottom: 10,
                              left: 15
                          ),
                          decoration: BoxDecoration(
                            color:
                            _messages[i].sender != 'user' ?
                            const Color.fromRGBO(14, 14, 14, 1) : const Color.fromRGBO(0, 80, 239, 1),
                            border: Border.all(
                                color: const Color.fromRGBO(255, 255, 255, 0.15)
                            ),
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20),
                                topRight: const Radius.circular(20),
                                bottomRight:
                                _messages[i].sender == 'user' ? Radius.zero : const Radius.circular(20),
                                bottomLeft:
                                _messages[i].sender != 'user' ? Radius.zero : const Radius.circular(20)
                            ),
                          ),
                          child: _messages[i].sender != 'user' ?
                          GradientText(
                              _messages[i].message,
                              colors: const [
                                Color.fromRGBO(255, 0, 251, 1),
                                Color.fromRGBO(0, 58, 255, 1),
                              ]
                          ) : Text(
                            _messages[i].message.length > 15 ? '...' : _messages[i].message,
                            style: const TextStyle(
                                color: Colors.white
                            ),
                          )
                      )
                    ],
                  ),
                ),
                if (i == 0 && aiGenerating) Container(
                  margin: const EdgeInsets.only(
                    top: 18
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 24,
                        color: Colors.white,
                      ),
                     SizedBox(
                       width: 100,
                       height: 50,
                       child: Image(
                         fit: BoxFit.cover,
                         image: AssetImage('assets/images/load/loading.gif'),
                       ),
                     )
                    ],
                  ),
                )
              ],
            );
          }
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.only(
              top: 16,
              right: 30,
              bottom: 16,
              left: 30
          ),
          decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32),
                  topLeft: Radius.circular(32)
              )
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  // maxLines: null,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _textFiledIsNotEmpty = true;
                      });
                    } else {
                      setState(() {
                        _textFiledIsNotEmpty = false;
                      });
                    }
                  },
                  controller: _sendTextController,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide.none
                    ),
                    filled: true,
                    fillColor: const Color.fromRGBO(30, 30, 30, 1),
                    isDense: true,
                    contentPadding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                    hintText: 'Type your message...',
                    hintStyle: const TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.6),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    if (_sendTextController.text.isNotEmpty) {
                      _playSendAudio();
                      setState(() {
                        aiGenerating = true;
                      });
                      final userMessage = _sendTextController.text;
                      _sendTextController.clear();
                      final AiMessage userNewMessage = AiMessage(
                        message: userMessage,
                        sender: 'user',
                      );

                      fetchAiRequest() async {
                        String token = await SecureStorage().readSecureData('token');

                        final response = await http.post(
                            Uri.parse('https://flashthread.adaptable.app/api/ai'),
                            body: {
                              "userToken": token,
                              "history": jsonEncode(_history) as dynamic,
                              "message": userMessage
                            }
                        );

                        print(response.body);
                        setState(() {
                          aiGenerating = false;
                        });

                        if (response.statusCode == 201) {
                          final jsonDataMap = jsonDecode(response.body);
                          final jsonData = AiData.fromJson(jsonDataMap);
                          final AiMessage aiNewMessage = AiMessage(
                            message: jsonData.aiGeneratedMessage.isEmpty
                                ? 'Enter another text' : jsonData.aiGeneratedMessage,
                            sender: 'model',
                          );

                          _history.add({
                            "role": 'user',
                            "parts": userMessage,
                          });
                          _history.add({
                            "role": 'model',
                            "parts": jsonData.aiGeneratedMessage,
                          });

                          setState(() {
                            _playNotifyAudio();
                            _messages.insert(0, aiNewMessage);
                          });
                        } else {
                          throw Exception('get user not successfully');
                        }
                      }
                      fetchAiRequest();

                      setState(() {
                        _messages.insert(0, userNewMessage);
                      });
                    }
                  },
                  icon: Icon(
                    Icons.send,
                    color: _textFiledIsNotEmpty ? Colors.deepPurple : Colors.grey,
                  )
              )
            ],
          ),
        ),
      )
    );
  }

}