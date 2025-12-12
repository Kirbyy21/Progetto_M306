import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data_provider.dart';
import 'pages/home.dart';
import 'pages/calendar.dart';
import 'pages/info_horses.dart';
import 'pages/race.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'theme.dart';
import 'package:calendar_event_linker/calendar_event_linker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Prende i cavalli preferiti (se ci sono)
  await Hive.initFlutter();
  await Hive.openBox<int>('favorite_horses');

  //await NotiService().initNotification();

  runApp(
    ChangeNotifierProvider(
      create: (_) => DataProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'JRace',
        theme: raceTheme,
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MyApp> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      await dataProvider.fetchData();
      final permission = await Permission.calendarFullAccess.request();
      if (permission.isGranted) {
        createEventCalendar(dataProvider.races);
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> createEventCalendar(final races) async {
    final calendarEventLinker = CalendarEventLinker();
    DateTime today = DateTime.now();
    for (var race in races) {
      DateTime date = DateTime.parse(race["date"]);
      if ((date.isAtSameMomentAs(today) || date.isAfter(today)) && date.year >= today.year) {
        try {
          final eventId = await calendarEventLinker.addEventToCalendar(
            title: '${race["date"]} Race Day',
            description: 'Today is ${race["name"]} race day',
            startTime: DateTime(date.year, date.month, date.day, 7, 0),
            endTime: DateTime(date.year, date.month, date.day, 8, 0),
          );

          if (eventId != null) {
            print('Event added successfully with ID: $eventId');
          }
          else {
            print('Failed to add event');
          }
        }
        catch (e) {
          print('Error adding event for ${race["name"]} on ${race["date"]}: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    // Mostra caricamento finché i dati non sono pronti
    if (!dataProvider.isLoaded) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final List<Widget> _pages = [
      HomePage(),
      CalendarPage(),
      RacePage(),
      HorseDetailsPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendar"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Races"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Horses"),
        ],
      ),
    );
  }
}
