import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_provider.dart';

class RacePage extends StatelessWidget {
  const RacePage({super.key});
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataProvider>(context, listen: false).races;
    if (data.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    final uniqueRaces = <String, Map<String, dynamic>>{};

    for (var race in data) {
      final name = race['name'] ?? '';
      if (!uniqueRaces.containsKey(name)) {
        uniqueRaces[name] = race;
      }
    }

    final filteredRaces = uniqueRaces.values.toList();
    return ListView.builder(
      itemCount: filteredRaces.length,
      itemBuilder: (context, index) {
        final race = filteredRaces[index];
        return ListTile(
          title: Text(race["name"] ?? "N/A"),
          subtitle: Text("Location: ${race["location"] ?? "Unknown"}"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RaceDetailPage(race: race),
              ),
            );
          },
        );
      },
    );
  }
}

class RaceDetailPage extends StatelessWidget {
  const RaceDetailPage({super.key, required this.race});
  final Map<String, dynamic> race;
  @override
  Widget build(BuildContext context) {
    final races = Provider.of<DataProvider>(context, listen: false).races;
    final horses = Provider.of<DataProvider>(context, listen: false).horses;
    final results = Provider.of<DataProvider>(context, listen: false).results;

    final pastRaces = races.where((item) => item['name'] == race['name']).toList();

    DateTime today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(race["name"] ?? "Race Detail"),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Location: ${race["location"] ?? "Unknown"}"),
            Text(
              "Past Races:",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ...pastRaces.map((pastRace) {
              if (!DateTime.parse(pastRace["date"]).isBefore(today)) return SizedBox.shrink();

              final final_results = results.where((r) => r["raceId"] == pastRace["id"]).toList();

              final_results.sort((a, b) => a["position"].compareTo(b["position"]));

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date: ${pastRace["date"]}"),
                    const Text("Participants:"),
                    ...final_results.map((res) {
                      final horse = horses.firstWhere(
                            (h) => h["id"] == res["horseId"],
                            orElse: () => null,
                      );
                      return Row(
                          children: [
                              SizedBox(
                                width: 120,
                                child: Text("${res["position"]}. ${horse?["name"] ?? "Unknown"}"),
                              ),
                              Text("${res?['time'] ?? "N/A"}"),
                          ],
                      );
                    }),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}