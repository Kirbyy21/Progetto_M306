import 'package:flutter/material.dart';
import 'package:jracefolder/pages/info_horses.dart';
import 'package:provider/provider.dart';
import '../data_provider.dart';

// Pagina home
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fav = HorseDetailsPage.getAll();
    final horses = Provider.of<DataProvider>(context, listen: false).horses;
    final races = Provider.of<DataProvider>(context, listen: false).races;
    final fhors = [];
    final upRaces = [];
    DateTime today = DateTime.now();
      for (int i = 0; i < horses.length; i++) {
        final horse = horses[i];
        if (i == 0) {
          fhors.add({"name": "Favorite Horses:"});
        }
        if (HorseDetailsPage.isFavorite(horse["id"])) {
          fhors.add(horse);
        }
      }
    for (int i = 0; i < races.length; i++) {
      final race = races[i];
      if (i == 0) {
        upRaces.add({"name": "Upcoming races this year:"});
      }
      DateTime date = DateTime.parse(race["date"]);
      if (date.isAfter(today) && date.year == today.year) {
        upRaces.add(race);
      }
    }
    if (upRaces.length == 1) {
      upRaces.add({"name": "No races left for this year"});
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF149109),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: EdgeInsets.all(8),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: upRaces.length,
                itemBuilder: (context, index) {
                  final race = upRaces[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text(
                      "${race["name"]}${race["date"] != null ? '\n${race["date"]}' : ''}",
                      style: TextStyle(
                        fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,
                        fontSize: index == 0 ? 18 : 16,
                      ),
                    ),
                  );
                },
              ),
            ),
            Card(
              margin: EdgeInsets.all(8),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: fhors.length,
                itemBuilder: (context, index) {
                  final horse = fhors[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text(
                      horse["name"],
                      style: TextStyle(
                        fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,
                        fontSize: index == 0 ? 18 : 16,
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