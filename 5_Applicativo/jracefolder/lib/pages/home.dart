import 'package:flutter/material.dart';
import 'package:jracefolder/pages/info_horses.dart';
import 'package:provider/provider.dart';
import '../data_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fav = HorseDetailsPage.getAll();
    final horses = Provider.of<DataProvider>(context, listen: false).horses;
    final races = Provider.of<DataProvider>(context, listen: false).races;
    final fhors = [];
    final upRaces = [];
    DateTime today = DateTime.now();
    if (fav.isEmpty) {
      return Text("No favorite Horses");
    }
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
        upRaces.add({"name": "Upcoming races:"});
      }
      DateTime date = DateTime.parse(race["date"]);
      if (date.isAfter(today)) {
        upRaces.add(race);
      }
    }
    return ListView.builder(
        itemCount: upRaces.length,
        itemBuilder: (context, index) {
          final race = upRaces[index];
          return ListTile(
            title: Text(race["name"], style: TextStyle(
                fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,
                fontSize: index == 0 ? 18 : 16),),
            subtitle: Text(index == 0 ? "" : race["date"]),
          );

        }
    );
    /*return ListView.builder(
        itemCount: fhors.length,
        itemBuilder: (context, index) {
          final horse = fhors[index];
          final padding = EdgeInsets.only(
            left: 16,
            bottom: index == 0 ? 8 : 0,
          );
          return ListTile(
            title: Text(horse["name"], style: TextStyle(
              fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,
              fontSize: index == 0 ? 18 : 16),),
              contentPadding: padding,
          );
        }
    );*/
  }
}