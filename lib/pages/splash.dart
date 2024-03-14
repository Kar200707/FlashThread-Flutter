import 'package:FlashThread/data/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
import 'package:simple_animations/movie_tween/movie_tween.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});
  
  @override
  State<StatefulWidget> createState() => SplashState();
}

class SplashState extends State<Splash> {

  final MovieTween tween = MovieTween()
    ..scene(
        begin: const Duration(milliseconds: 0),
        end: const Duration(milliseconds: 500))
        .tween('opacity', Tween(begin: 0.4, end: 1.0))
    ..scene(
        begin: const Duration(milliseconds: 0),
        end: const Duration(milliseconds: 0))
  .thenTween('y', Tween(begin: 0.0, end: 20.0), duration: const Duration(milliseconds: 500));

  @override
  void initState() {
    super.initState();

    runTestPage() async {
      String? token = await SecureStorage().readSecureData('token');

      if (token != null) {
        Navigator.of(context).pushNamedAndRemoveUntil('/chats-menu', (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
    }

    runTestPage();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Container(
          child: CustomAnimationBuilder<Movie>(
            control: Control.mirror,
            tween: tween,
            duration: tween.duration,
            curve: Curves.easeInCirc,
            builder: (context, value, child) {
              return Opacity(
                opacity: value.get('opacity'),
                child: Transform.translate(
                  offset: Offset(0, value.get('y')),
                  child: Image.asset('assets/images/side-icons/flash-thread-colors.png'),
                ),
              );
            },
            child: const Center(
                child: Text('Hello!',
                    style: TextStyle(color: Colors.white, fontSize: 24))),
          ),
        ),
      ),
    );
  }
}