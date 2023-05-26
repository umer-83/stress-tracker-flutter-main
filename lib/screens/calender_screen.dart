import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:testproject/routes.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key? key}) : super(key: key);

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
              children: [
                Text(months[_dateShowing.month - 1]),
                Text(_dateShowing.year.toString())
              ],
            ),
            CalendarCarousel(
              onDayPressed: (DateTime date, List events) {
                setState(() => _currentDate = date);
                Navigator.pushNamed(context, Routes.STRESS_STATUS);
              },
              weekendTextStyle: const TextStyle(
                color: Colors.red,
              ),
              thisMonthDayBorderColor: Colors.grey,
              customDayBuilder: (
                /// you can provide your own build function to make custom day containers
                bool isSelectable,
                int index,
                bool isSelectedDay,
                bool isToday,
                bool isPrevMonthDay,
                TextStyle textStyle,
                bool isNextMonthDay,
                bool isThisMonthDay,
                DateTime day,
              ) {
                // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
                // if (day.day == 15) {
                //   return const Center(
                //     child: Icon(Icons.local_airport),
                //   );
                // }
                const redDays = [5, 6, 7, 8];
                if (redDays.contains(day.day)) {
                  return Container(
                    color: Colors.red,
                    child: Center(
                      child: Text(
                        day.day.toString(),
                      ),
                    ),
                  );
                }

                return null;
              },
              weekFormat: false,
              showHeader: false,
              // markedDatesMap: _markedDateMap,
              height: 420.0,
              selectedDateTime: _dateShowing,
              daysHaveCircularBorder: false,
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
