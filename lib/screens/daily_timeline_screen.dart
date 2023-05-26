import 'package:flutter/material.dart';
import 'package:testproject/routes.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class Ti {
  Ti({
    this.text = '',
    this.color = Colors.grey,
    this.textColor = Colors.black87,
    this.fontSize = 16.0,
  });

  String text;
  Color color;
  Color textColor;
  double fontSize;
}

class _CalenderScreenState extends State<CalenderScreen> {
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

  var timeline = [
    [
      Ti(text: 'Days', color: Colors.blueGrey, textColor: Colors.white),
      Ti(
          text: '8am-10am',
          color: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 10),
      Ti(
          text: '10am-12pm',
          color: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 10),
      Ti(
          text: '12pm-2pm',
          color: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 10),
      Ti(
          text: '2pm-4pm',
          color: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 10),
    ],
    [
      Ti(text: 'Sun'),
      Ti(),
      Ti(color: Colors.green),
      Ti(),
      Ti(color: Colors.green),
    ],
    [
      Ti(text: 'Mon'),
      Ti(),
      Ti(color: Colors.deepOrange),
      Ti(color: Colors.deepOrange),
      Ti(),
    ],
    [
      Ti(text: 'Tues'),
      Ti(color: Colors.green),
      Ti(),
      Ti(),
      Ti(color: Colors.deepOrange),
    ],
    [
      Ti(text: 'Wed'),
      Ti(color: Colors.green),
      Ti(),
      Ti(),
      Ti(),
    ],
    [
      Ti(text: 'Thu'),
      Ti(color: Colors.deepOrange),
      Ti(color: Colors.deepOrange),
      Ti(color: Colors.deepOrange),
      Ti(),
    ],
  ];

  List<Widget> _buildTable() {
    return timeline.map((tr) {
      var tds = <Widget>[];

      tds = tr.map((td) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routes.STRESS_STATUS);
            },
            child: Container(
              color: td.color,
              height: 50,
              margin: const EdgeInsets.all(2),
              child: Center(
                child: Text(
                  td.text,
                  style: TextStyle(color: td.textColor, fontSize: td.fontSize),
                ),
              ),
            ),
          ),
        );
      }).toList();

      return Row(children: tds);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stress History'),
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
                children: const [
                  TableRow(
                    children: [
                      TableCell(
                        child: Text("Name"),
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
                        child: Text("29384"),
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
              children: const [
                Icon(Icons.arrow_back),
                Text(
                  '10 Jun - 14 Jun',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Icon(Icons.arrow_forward),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: _buildTable(),
            ),
            const SizedBox(
              height: 20,
            ),
            Table(
              children: const [
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
          ],
        ),
      ),
    );
  }
}
