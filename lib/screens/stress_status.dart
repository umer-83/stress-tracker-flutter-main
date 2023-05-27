import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testproject/routes.dart';

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
    // Replace 123 with the actual user ID variable
    fetchStressList(1);
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
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'Name',
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Ali Ahmed',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Stress Status',
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: SizedBox(
                            height: 30,
                            child: Image.asset(
                              "static/images/stressed_icon.png",
                              scale: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'History',
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                        IconButton(
                          icon: const Icon(Icons.history),
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.CALENDAR);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
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
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: stressColor,
                    ),
                  );

                  return Card(
                    elevation: 2,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                          const SizedBox(height: 8),
                        ],
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
