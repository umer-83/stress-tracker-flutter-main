import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:testproject/user_id_provider.dart';

class StressCalendarScreen extends StatefulWidget {
  @override
  _StressCalendarScreenState createState() => _StressCalendarScreenState();
}

class _StressCalendarScreenState extends State<StressCalendarScreen> {
  List<StressEntry> stressList = [];
  late DateTime _firstDate;
  late DateTime _lastDate;
  late DateTime _selectedDate;
  String _employeeId = '';

  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  Future<void> fetchStressHistory(String userId) async {
    final url = Uri.parse('http://16.16.96.75:8000/stress/history?_id=$userId');
    final response = await http.get(url);
    final responseData = json.decode(response.body);

    setState(() {
      stressList =
          List<StressEntry>.from(responseData['stress_list']['List'].map(
        (entry) => StressEntry(
          dateTime: DateTime.parse(entry[0]),
          isStressed: entry[1],
        ),
      ));

      if (stressList.isNotEmpty) {
        _firstDate = stressList.first.dateTime!;
        _lastDate = stressList.last.dateTime!;
        _selectedDate = _firstDate;
      } else {
        final now = DateTime.now();
        _firstDate = now;
        _lastDate = now;
        _selectedDate = now;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final userIdProvider = Provider.of<UserIdProvider>(context, listen: false);
    final userId = userIdProvider.employeeId;
    if (userId != null) {
      fetchStressHistory(userId);
    }
    // Set default values for _firstDate, _lastDate, and _selectedDate
    final now = DateTime.now();
    _firstDate = now;
    _lastDate = now;
    _selectedDate = now;

    _employeeId = userIdProvider.employeeId ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stress Calendar'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: _goToPreviousWeek,
                ),
                Text(
                  '${_dateFormat.format(_selectedDate.subtract(Duration(days: 6)))} - ${_dateFormat.format(_selectedDate)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: _goToNextWeek,
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: 64, // 8 columns x 8 rows
              itemBuilder: (context, index) {
                final dayIndex = index % 8;
                final timeIndex = index ~/ 8;

                if (index == 0) {
                  // Empty cell at the top left corner
                  return Container();
                } else if (dayIndex == 0 && timeIndex == 0) {
                  // Cell at (0, 0) position with no data
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.grey.shade200,
                    ),
                  );
                } else if (dayIndex == 0) {
                  // Time labels
                  final timeLabelIndex = timeIndex - 1;
                  final timeLabel = getTimeLabel(timeLabelIndex);

                  return Container(
                    alignment: Alignment.center,
                    color: Colors.grey.shade200,
                    child: Text(timeLabel),
                  );
                } else if (timeIndex == 0) {
                  // Day labels
                  final dayLabelIndex = dayIndex;
                  final dayLabel = getDayLabel(dayLabelIndex);

                  return Container(
                    alignment: Alignment.center,
                    color: Colors.grey.shade200,
                    child: Text(dayLabel),
                  );
                } else {
                  // Stress data cells
                  final day = _selectedDate.subtract(Duration(days: 6)).day +
                      dayIndex -
                      1;
                  final time = timeIndex - 1;

                  final stressEntry = stressList.firstWhere(
                    (entry) =>
                        entry.dateTime?.day == day &&
                        entry.dateTime!.hour >= time * 2 &&
                        entry.dateTime!.hour < (time + 1) * 2,
                    orElse: () =>
                        StressEntry(dateTime: null, isStressed: false),
                  );

                  Color cellColor;
                  if (stressEntry.dateTime != null) {
                    cellColor =
                        stressEntry.isStressed ? Colors.red : Colors.green;
                  } else {
                    cellColor = Colors.grey;
                  }

                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      color: cellColor,
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Employee ID: $_employeeId',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _goToPreviousWeek() {
    if (_selectedDate.isAtSameMomentAs(_firstDate)) return;

    final newSelectedDate = _selectedDate.subtract(Duration(days: 7));

    setState(() {
      _selectedDate = newSelectedDate;
    });
  }

  void _goToNextWeek() {
    if (_selectedDate.isAtSameMomentAs(_lastDate)) return;

    final newSelectedDate = _selectedDate.add(Duration(days: 7));

    setState(() {
      _selectedDate = newSelectedDate;
    });
  }

  String getTimeLabel(int index) {
    switch (index) {
      case 0:
        return '7am-9am';
      case 1:
        return '9am-11am';
      case 2:
        return '11am-1pm';
      case 3:
        return '1pm-3pm';
      case 4:
        return '3pm-5pm';
      case 5:
        return '5pm-7pm';
      case 6:
        return '7pm-9pm';
      default:
        return '';
    }
  }

  String getDayLabel(int index) {
    switch (index) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}

class StressEntry {
  final DateTime? dateTime;
  final bool isStressed;

  StressEntry({this.dateTime, required this.isStressed});
}
