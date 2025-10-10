import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}


class _CalendarPageState  extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late final Map<DateTime, List<dynamic>> race;

  @override
  void initState() {
    super.initState();
    final races = Provider.of<DataProvider>(context, listen: false).races;
    race = _groupEvents(races);
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<dynamic> races) {
    final map = <DateTime, List<dynamic>>{};
    for (var dateStr in races) {
      final parsed = DateTime.parse(dateStr['date']);
      final dateOnly = DateTime(parsed.year, parsed.month, parsed.day);
      map.putIfAbsent(dateOnly, () => []).add(dateStr);
    }
    return map;
  }

  List<dynamic> _getEvents(DateTime day) {
    return race[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    if (race.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return TableCalendar(
      rowHeight: 75,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,

        todayDecoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.lightBlue,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
        ),
        markerDecoration: BoxDecoration(
          color: Colors.blue[900],
          shape: BoxShape.circle,
        ),
        defaultDecoration: BoxDecoration(
          border: Border.all(
            color: Colors.lightBlue,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        weekendDecoration: BoxDecoration(
          border: Border.all(
            color: Colors.lightBlue,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      firstDay: DateTime.utc(2015,10,16),
      lastDay: DateTime.utc(2030,3,14),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
      eventLoader: (day) {
        final dateOnly = DateTime(day.year, day.month, day.day);
        return race[dateOnly] ?? [];
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
    );
  }
}