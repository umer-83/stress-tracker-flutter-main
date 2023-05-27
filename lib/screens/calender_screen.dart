import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:testproject/routes.dart';

class CalenderScreen extends StatefulWidget {
  final int employeeId;

  const CalenderScreen({Key? key, required this.employeeId}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  DateTime _currentDate = DateTime.now();
  DateTime _dateShowing = DateTime(2021, 8, 20);

  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  List<dynamic> stressHistory = [];

  Future<void> fetchStressHistory() async {
    final url =
        '${Routes.BASE_URL}${Routes.STRESS_HISTORY}?_id=${widget.employeeId}&start_datetime=2022-01-01&end_datetime=2022-12-31';
    final response = await http.get(Uri.parse(url));
    

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        stressHistory = responseData['stress_list'];
      });
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to fetch stress history'),
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
    fetchStressHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30.0),
            SizedBox(
              width: 150,
              child: Table(
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Text(widget.employeeId.toString()),
                      ),
                      TableCell(
                        child: Text("Ahmed"),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Text("ID"),
                      ),
                      TableCell(
                        child: Text(widget.employeeId.toString()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(months[_dateShowing.month - 1]),
                Text(_dateShowing.year.toString())
              ],
            ),
            // CalendarCarousel widget code
            // ...

            Table(
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Text("Number of stressed days"),
                    ),
                    TableCell(
                      child: Text("15"),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text("Number of not stressed days"),
                    ),
                    TableCell(
                      child: Text("7"),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Stress History',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: stressHistory.length,
                itemBuilder: (ctx, index) {
                  final stressItem = stressHistory[index];
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
