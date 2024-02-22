import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskify/models/task.dart';
import "package:collection/collection.dart";
import 'package:taskify/widgets/custom_app_bar.dart';

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year + 100, kToday.month + 3, kToday.day);

class CalendarRoute extends StatefulWidget {
  final List<Task> tasks;
  const CalendarRoute({super.key, required this.tasks});

  @override
  _CalendarRouteState createState() => _CalendarRouteState();
}

class _CalendarRouteState extends State<CalendarRoute> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime? _selectedDay;

  List<Task> _getEventsForDay(DateTime day) {
    // Implementation example
    final events = groupBy(widget.tasks.where((element) => element.due != null),
        (item) => item.due.toString().substring(0, 10));

    return events[day.toString().substring(0, 10)] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      final exams = _getEventsForDay(selectedDay);

      if (exams.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text("Date ${selectedDay.toString().substring(0, 10)}"),
              ),
              body: ListView.builder(
                itemCount: exams.length,
                itemBuilder: (context, index) {
                  final item = exams[index];

                  return ListTile(
                    title: Text(
                      item.due!.toIso8601String(),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${item.due!.hour}:${item.due!.minute}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Calendar'),
      body: Column(
        children: [
          TableCalendar<Task>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: DateTime.now(),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              markersAlignment: Alignment.bottomRight,
            ),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) => events.isNotEmpty
                  ? Container(
                      width: 16,
                      height: 16,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                      ),
                      child: Text(
                        '${events.length}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
