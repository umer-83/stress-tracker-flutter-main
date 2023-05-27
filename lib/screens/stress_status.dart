import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testproject/routes.dart';
import 'package:provider/provider.dart';
import 'package:testproject/user_id_provider.dart';

class StressStatusScreen extends StatefulWidget {
  const StressStatusScreen({Key? key}) : super(key: key);

  @override
  State<StressStatusScreen> createState() => _StressStatusScreenState();
}

class _StressStatusScreenState extends State<StressStatusScreen> {
  List<dynamic> stressList = [];

  Future<void> fetchStressList(int userId) async {
    final url = '${Routes.BASE_URL}${Routes.STRESS_LIST}?_id=$userId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        stressList = responseData['stress_list'];
      });
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
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.NOTIFICATIONS);
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.notifications_active,
                color: Colors.white60,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'Stress List',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: stressList.length,
                itemBuilder: (ctx, index) {
                  final stressItem = stressList[index];
                  final stressLevel = stressItem['stress-status'];
                  final stressColor = stressLevel ? Colors.red : Colors.green;
                  final stressCircle = Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: stressColor,
                    ),
                  );

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.CALENDAR,
                        arguments: stressItem['employee-id'],
                      );
                    },
                    child: Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(
                          stressItem['name'],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                stressCircle,
                                const SizedBox(width: 8),
                                Text(
                                  stressLevel
                                      ? 'High Stress Level'
                                      : 'Low Stress Level',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Datetime: ${stressItem['datetime']}',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Employee ID: ${stressItem['employee-id']}',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
