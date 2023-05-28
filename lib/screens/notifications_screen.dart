import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testproject/routes.dart';
import 'package:provider/provider.dart';
import 'package:testproject/user_id_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> stressList = [];

  Future<void> fetchStressList(int userId) async {
    final url = '${Routes.BASE_URL}${Routes.STRESS_LIST}?_id=$userId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        stressList = responseData['stress_list'];
      });

      // Filter the stress list by high-stress level entries
      final highStressList = stressList
          .where((stressItem) => stressItem['stress-status'] == true)
          .toList();

      // Show a notification if there are high-stress level entries
      if (highStressList.isNotEmpty) {
        showNotification();
      }
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to fetch stress list'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void showNotification() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('High Stress Level'),
        content: const Text('There are employees with high stress level'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final userIdProvider = Provider.of<UserIdProvider>(context, listen: false);
    final userId = int.parse(userIdProvider.userId!); // Convert to int
    fetchStressList(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: stressList.length,
        itemBuilder: (ctx, index) {
          final stressItem = stressList[index];
          final stressLevel = stressItem['stress-status'];

          // Show only high-stress level entries
          if (stressLevel) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.CALENDAR,
                  arguments: stressItem['employee-id'],
                );
              },
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ID: ${stressItem['employee-id']}"),
                      Text("The operator is Stressed"),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container(); // Skip rendering low-stress level entries
          }
        },
      ),
    );
  }
}
