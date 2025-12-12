import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_provider.dart';

// Pagina per visualizzare le corse
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
    return Scaffold(
        appBar: AppBar(title: Text("Races",  style: TextStyle(color: Colors.white),), backgroundColor:  Color(0xFF149109),),
        body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                itemCount: filteredRaces.length,
                itemBuilder: (context, index) {
                  final race = filteredRaces[index];
                  return Card(
                    child: ListTile(
                      title: Text(race["name"] ?? "N/A"),
                      subtitle: Text("Location: ${race["location"] ?? "Unknown"}"),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RaceDetailPage(race: race),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        )
    );
  }
}

// Pagina per visulizzare le corse passate
class RaceDetailPage extends StatelessWidget {
  const RaceDetailPage({super.key, required this.race});
  final Map<String, dynamic> race;
  @override
  Widget build(BuildContext context) {
    final races = Provider.of<DataProvider>(context, listen: false).races;
    final horses = Provider.of<DataProvider>(context, listen: false).horses;
    final results = Provider.of<DataProvider>(context, listen: false).results;
    DateTime today = DateTime.now();
    final pastRaces = races.where((item) => item['name'] == race['name']).toList();
    final pstRaces = [];
    for (int i = 0; i < pastRaces.length; i++) {
      final race = pastRaces[i];

      DateTime date = DateTime.parse(race["date"]);
      if (date.isAfter(today)) {
        pstRaces.add(race);
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(race["name"] ?? "Race Detail"),
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Location: ${race["location"] ?? "Unknown"}"),
            Text(pstRaces.isNotEmpty ? "" : "Past Races:",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ...pastRaces.map((pastRace) {
              if (!DateTime.parse(pastRace["date"]).isBefore(today)) return SizedBox.shrink();

              final finalResults = results.where((r) => r["raceId"] == pastRace["id"]).toList();

              finalResults.sort((a, b) => a["position"].compareTo(b["position"]));

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date: ${pastRace["date"]}"),
                    const Text("Participants:"),
                    ...finalResults.map((res) {
                      final horse = horses.firstWhere(
                            (h) => h["id"] == res["horseId"],
                            orElse: () => null,
                      );
                      return Row(
                          children: [
                              SizedBox(
                                width: 175,
                                child: Text("${res["position"]}. ${horse?["name"] ?? "Unknown"}"),
                              ),
                              Text("${res?['time'] ?? "N/A"}"),
                          ],
                      );
                    }),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}