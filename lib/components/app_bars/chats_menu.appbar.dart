import 'dart:convert';

import 'package:FlashThread/models/full_user_data.dart';
import 'package:FlashThread/models/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
import 'package:http/http.dart' as http;
import 'package:simple_animations/simple_animations.dart';

class ChatsMenuAppBar extends StatefulWidget implements PreferredSizeWidget {
  final UserData? user;
  final openDrawer;
  const ChatsMenuAppBar({super.key, required this.user, required this.openDrawer,});

  @override
  Size get preferredSize => const Size.fromHeight(180);

  @override
  State<StatefulWidget> createState() => ChatsMenuAppBarState();
}

class ChatsMenuAppBarState extends State<ChatsMenuAppBar> with TickerProviderStateMixin {
  bool _isSearchFocus = false;
  FullUserData? _searchUser;
  late AnimationController _controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this
    )
      ..addListener(() {
        setState(() {});
      });
    scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.05,
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutExpo
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32)
            )
        ),
        padding: const EdgeInsets.only(
            top: 44,
            bottom: 24,
            left: 24,
            right: 24
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Messages',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.openDrawer();
                  },
                  onTapCancel: () {
                    print('tap cancel');
                  },
                  child:  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color.fromRGBO(0, 80, 239, 1), width: 2)
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.transparent, width: 4)
                      ),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(widget.user!.avatar),
                              fit: BoxFit.cover
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            ScaleTransition(
              scale: scaleAnimation,
              child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(38, 38, 38, 1),
                      borderRadius: _isSearchFocus ?
                      const BorderRadius.only(
                          topLeft: Radius.circular(26),
                          topRight: Radius.circular(26)
                      ) : BorderRadius.circular(100)
                  ),
                  margin: const EdgeInsets.only(top: 32),
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Focus(
                            onFocusChange: (hasFocus) {
                              if (hasFocus) {
                                setState(() {
                                  _isSearchFocus = true;
                                  _controller.play();
                                });
                              } else {
                                setState(() {
                                  _isSearchFocus = false;
                                  _controller.playReverse();
                                });
                              }
                            },
                            child: TextField(
                              onChanged: (value) {
                                fetchSearch() async {
                                  final response = await http.post(
                                      Uri.parse('https://flashthread.adaptable.app/api/search-user'),
                                      body: {
                                        "name": value,
                                      }
                                  );

                                  if (response.statusCode == 201) {
                                    final jsonDataList = jsonDecode(response.body) as List<dynamic>;
                                    if (jsonDataList.isNotEmpty) {
                                      final Map<String, dynamic> userDataJson = jsonDataList[0] as Map<String, dynamic>;
                                      final FullUserData userData = FullUserData.fromJson(userDataJson);

                                      setState(() {
                                        _searchUser = userData;
                                      });
                                    } else {
                                      setState(() {
                                        _searchUser = null;
                                      });
                                    }
                                  } else {
                                    throw Exception('get user not successfully');
                                  }
                                }
                                fetchSearch();
                              },
                              style: const TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                isDense: true,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Color.fromRGBO(255, 255, 255, 0.6),
                                  size: 24,
                                ),
                                contentPadding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                                hintText: 'Type your search...',
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 0.6),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                          if (_isSearchFocus) CustomAnimationBuilder(
                              builder: (context, value, child) {
                                return Positioned(
                                  top: 51,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    height: value,
                                    decoration: BoxDecoration(
                                        boxShadow: kElevationToShadow[1],
                                        color: const Color.fromRGBO(38, 38, 38, 1),
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20)
                                        )
                                    ),
                                    child: _searchUser != null && _searchUser!.id != widget.user!.id ? SingleChildScrollView(
                                      child: Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: const Color.fromRGBO(89, 89, 89, 1.0), width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                          color: const Color.fromRGBO(
                                              63, 63, 63, 1.0),
                                          // borderRadius: BorderRadius.circular(15)
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(80),
                                                  image: DecorationImage(
                                                      image: NetworkImage(_searchUser!.avatar),
                                                      fit: BoxFit.cover
                                                  )
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 15
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _searchUser!.name,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Poppins',
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                  Text(
                                                    _searchUser!.bio,
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontFamily: 'Poppins',
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ) : null,
                                  ),
                                );
                              },
                              curve: Curves.easeOutExpo,
                              tween: Tween<double>(begin: 0, end: 130),
                              duration: const Duration(milliseconds: 540)
                          ),
                        ],
                      )
                    ],
                  )
              ),
            )
          ],
        )
    );
  }
}