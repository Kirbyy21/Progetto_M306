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

  /*List<dynamic> _getEvents(DateTime day) {
    return race[DateTime(day.year, day.month, day.day)] ?? [];
  }*/

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
          color: Colors.blueAccent,
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
          border: Border.all(color: Colors.red, width: 4),
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

        final dateOnly = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
        final events = race[dateOnly] ?? [];

        if (events.isNotEmpty) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return DraggableScrollableSheet(
                initialChildSize: 0.5,
                expand: false,
                builder: (context, scollController) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    child: ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final race_event = events[index];
                        return Card(
                          child: ListTile(
                            title: Text(race_event["name"]),
                            subtitle: Text(race_event["location"]),
                          ),
                        );
                      }
                    ),
                  );
                }
              );
            }
          );
        }
      },
      calendarFormat: _calendarFormat,
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
    );
  }
}