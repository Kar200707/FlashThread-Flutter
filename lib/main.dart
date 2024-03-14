import 'package:FlashThread/pages/chats_menu.dart';
import 'package:FlashThread/pages/flash_ai.dart';
import 'package:FlashThread/pages/login.dart';
import 'package:FlashThread/pages/profile.dart';
import 'package:FlashThread/pages/register.dart';
import 'package:FlashThread/pages/settings.dart';
import 'package:FlashThread/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flash Thread',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black
      ),
      onGenerateRoute:  (settings) {
        {
          switch (settings.name) {
            case '/login':
              return PageTransition(
                settings: settings,
                child: const LoginPage(),
                type: PageTransitionType.theme,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOutExpo
              );
            case '/register':
              return PageTransition(
                settings: settings,
                child: const RegisterPage(),
                type: PageTransitionType.theme,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOutExpo
              );
            case '/chats-menu':
              return PageTransition(
                settings: settings,
                child: const ChatsMenuPage(),
                duration: const Duration(seconds: 1),
                type: PageTransitionType.theme,
                curve: Curves.easeInOutExpo
              );
            case '/splash':
              return PageTransition(
                settings: settings,
                child: const Splash(),
                type: PageTransitionType.fade,
              );
            case '/profile':
              return PageTransition(
                settings: settings,
                child: const ProfilePage(),
                duration: const Duration(milliseconds: 700),
                type: PageTransitionType.rightToLeft,
                isIos: true
              );
            case '/settings':
              return PageTransition(
                settings: settings,
                child: const SettingsPage(),
                duration: const Duration(milliseconds: 700),
                type: PageTransitionType.rightToLeft,
                isIos: true
              );
            case '/flash-ai':
              return PageTransition(
                settings: settings,
                child: const FlashAiPage(),
                type: PageTransitionType.rightToLeft,
                duration: const Duration(milliseconds: 700),
                isIos: true
              );
            default:
              return null;
          }
        }
      },
      initialRoute: '/splash',
      // routes: {
      //   '/login': (context) => const LoginPage(),
      //   '/register': (context) => const RegisterPage(),
      //   '/chats-menu': (context) => const ChatsMenuPage(),
      //   '/splash': (context) => const Splash(),
      //   '/profile': (context) => const ProfilePage(),
      //   '/settings': (context) => const SettingsPage(),
      //   '/flash-ai': (context) => const FlashAiPage(),
      // },
    );
  }
}