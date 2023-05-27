import 'package:flutter/material.dart';
import 'package:testproject/routes.dart' as routes;
import 'package:testproject/screens/daily_timeline_screen.dart';
import 'package:testproject/screens/login_screen.dart';
import 'package:testproject/screens/main_screen.dart';
import 'package:testproject/screens/notifications_screen.dart';
import 'package:testproject/screens/profile_screen.dart';
import 'package:testproject/screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        initialRoute: routes.Routes.LOGIN,
        routes: {
          
          routes.Routes.MAIN: (ctx) => const MainScreen(id: 'id',),
          routes.Routes.LOGIN: (ctx) => const LoginScreen(),
          routes.Routes.SIGNUP: (ctx) => const RegisterScreen(),
          routes.Routes.CALENDAR: (ctx) => const CalenderScreen(),
          routes.Routes.NOTIFICATIONS: (ctx) => const NotificationsScreen(),
          routes.Routes.PROFILE: (ctx) => const ProfileScreen(id: 'id'),
         
        });
  }
}
