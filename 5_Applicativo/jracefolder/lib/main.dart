import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horse Races',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse("https://jsonkeeper.com/b/ODADI");
    final response = await http.get(url);
    final Map<String, dynamic> decoded = jsonDecode(response.body);
    final List<dynamic> horses = decoded['horses'] ?? [];
    setState(() {
      data = horses;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomePage(data: data),
      CalendarPage(),
      ResultsPage(),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Results",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: "Horse",
          ),
        ],
      ),
    );
  }
}

/// < PAGINE >

class HomePage extends StatelessWidget {
  final List<dynamic> data;

  const HomePage({Key? key, required this.data}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final horse = data[index];
        return ListTile(
          title: Text(horse["name"] ?? "N/A"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: horse["alive"] == false
                ? [
              Text("Owner: ${horse["owner"] ?? "Unknown"}"),
              Text("Sex: ${horse["sex"] ?? "N/A"}"),
              Text("Died: ${horse["age"]?.toString() ?? "N/A"}"),
              Text("G1 Wins: ${horse["wins_G1"] ?? "N/A"}"),
              Text("G2 Wins: ${horse["wins_G2"] ?? "N/A"}"),
              Text("G3 Wins: ${horse["wins_G3"] ?? "N/A"}"),
            ]
                : [
              Text("Owner: ${horse["owner"] ?? "Unknown"}"),
              Text("Sex: ${horse["sex"] ?? "N/A"}"),
              Text("Age: ${horse["age"]?.toString() ?? "N/A"}"),
              Text("G1 Wins: ${horse["wins_G1"] ?? "N/A"}"),
              Text("G2 Wins: ${horse["wins_G2"] ?? "N/A"}"),
              Text("G3 Wins: ${horse["wins_G3"] ?? "N/A"}"),
            ],
          ),
          isThreeLine: true,
        );


      },
    );
  }
}

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Calendar Page"));
  }
}

class ResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Results Page"));
  }
}

class HorseDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Horse Details Page"));
  }
}
