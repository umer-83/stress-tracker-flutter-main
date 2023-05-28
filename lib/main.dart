import 'package:flutter/material.dart';
import 'package:testproject/routes.dart' as routes;
import 'package:testproject/screens/login_screen.dart';
import 'package:testproject/screens/main_screen.dart';
import 'package:testproject/screens/notifications_screen.dart';
import 'package:testproject/screens/profile_screen.dart';
import 'package:testproject/screens/register_screen.dart';
import 'package:provider/provider.dart';
import 'package:testproject/user_id_provider.dart' as provider;

void main() {
  runApp(ChangeNotifierProvider<provider.UserIdProvider>(
    create: (context) => provider.UserIdProvider(),
    child: MyApp(),
  ));
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
          routes.Routes.MAIN: (ctx) => const MainScreen(),
          routes.Routes.LOGIN: (ctx) => const LoginScreen(),
          routes.Routes.SIGNUP: (ctx) => const RegisterScreen(),
          routes.Routes.NOTIFICATIONS: (ctx) => const NotificationsScreen(),
          routes.Routes.PROFILE: (ctx) => ProfileScreen(),
        });
  }
}
