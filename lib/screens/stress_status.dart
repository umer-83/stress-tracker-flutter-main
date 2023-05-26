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

  Future<void> fetchStressList() async {
    final url = '${Routes.BASE_URL}${Routes.STRESS_LIST}';
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
    fetchStressList();
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
                  return ListTile(
                    title: Text(stressItem['name']),
                    subtitle:
                        Text('Stress Level: ${stressItem['stress-status']}'),
                    trailing: Text('Datetime: ${stressItem['datetime']}'),
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
