import 'package:flutter/material.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  const MainAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  State<StatefulWidget> createState() => MainAppBarState();
}

class MainAppBarState extends State<MainAppBar> {

  @override
  Widget build(BuildContext context) {
    String title = widget.title ?? 'untitled';

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
          left: 15
      ),
      child: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
        title: Text(title),
      ),
    );
  }
}