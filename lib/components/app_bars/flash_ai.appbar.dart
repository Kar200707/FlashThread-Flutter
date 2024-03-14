import 'package:FlashThread/data/secure_storage.dart';
import 'package:FlashThread/models/ai_message.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gradient_icon/gradient_icon.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:http/http.dart' as http;

class FlashAiAppBar extends StatefulWidget implements PreferredSizeWidget {
  var callback;
  FlashAiAppBar({super.key, required this.callback});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  State<StatefulWidget> createState() => FlashAiAppBarState();
}

class FlashAiAppBarState extends State<FlashAiAppBar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(32),
              bottomLeft: Radius.circular(32)
          )
      ),
      padding: const EdgeInsets.only(
          top: 16,
          right: 15,
          bottom: 16,
          left: 0
      ),
      child: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
        title: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Positioned(
                right: 0,
                left: 0,
                child:  Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          bottom: 15
                      ),
                      child: const GradientIcon(
                          icon: Icons.auto_awesome,
                          size: 30,
                          gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(255, 0, 251, 1),
                                Color.fromRGBO(0, 58, 255, 1)
                              ]
                          )
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 12
                      ),
                      child: GradientText(
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
                    )
                  ],
                ),
              ),
              Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                      onPressed: () async {
                        if (await confirm(
                            context,
                            content: const Text('if you click delete this ai chat will be permanently deleted'),
                            title: const Text('Delete This Ai Chat?'),
                            textOK: const Text('Delete', style: TextStyle(color: Colors.red),)
                        )) {
                          fetchDelete() async {
                            String token = await SecureStorage().readSecureData('token');

                            final response = await http.delete(
                                Uri.parse('https://flashthread.adaptable.app/api/ai/chat/delete'),
                                body: {
                                  "token": token
                                }
                            );

                            if (response.statusCode == 200) {
                              widget.callback();
                            } else {
                              throw Exception('delete not successfully');
                            }
                          }
                          fetchDelete();
                        }
                      },
                      icon: const Icon(
                        size: 30,
                        Icons.delete_sweep,
                        color: Colors.red,
                      )
                  )
              ),
            ],
          ),
        )
      ),
    );
  }
}