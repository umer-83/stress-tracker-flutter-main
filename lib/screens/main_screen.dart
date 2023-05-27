import 'package:flutter/material.dart';
import 'package:testproject/screens/profile_screen.dart';
import 'package:testproject/screens/stress_status.dart';
import 'package:testproject/screens/add_user_screen.dart';
import 'package:testproject/screens/login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int activeIndex = 0;

  Widget getActivePage() {
    switch (activeIndex) {
      case 0:
        return const StressStatusScreen();
      case 1:
        return const AddUserScreen();
      case 2:
        return ProfileScreen();
      case 3:
        return LoginScreen();
      default:
        return const StressStatusScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: getActivePage(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            Colors.blueGrey, // Set the background color of the navigation bar
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt_1),
            label: 'Add User',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: activeIndex,
        selectedItemColor: Colors
            .blueGrey, // Set the color of the selected item's icon and label
        unselectedItemColor: Colors
            .blueGrey, // Set the color of the unselected items' icons and labels
        onTap: (int index) {
          setState(() {
            activeIndex = index;
          });
        },
      ),
    );
  }
}
