import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import '../data_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HorseDetailsPage extends StatelessWidget {
  static final Box<int> box = Hive.box<int>('favorite_horses');

  static bool isFavorite(int id) {
    return box.containsKey(id);
  }
  static void addHorse(int id) {
    if (box.length >= 10) return;
    if (!box.containsKey(id)) {
      box.put(id, id);
    }
  }
  static void removeHorse(int id) {
    box.delete(id);
  }
  static List<int> getAll() {
    return box.keys.cast<int>().toList();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataProvider>(context, listen: false).horses;
    if (data.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final horse = data[index];
        return ListTile(
          title: Text(horse["name"] ?? "N/A", style: TextStyle(color: isFavorite(horse["id"]) ? Colors.redAccent : Colors.black),),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => HorseDetailPage(horse: horse),
              ),
            );
          }
        );
      },
    );
  }
}

class HorseDetailPage extends StatelessWidget {
  const HorseDetailPage({super.key, required this.horse});
  final Map<String, dynamic> horse;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(horse["name"] ?? "Horse Detail")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${horse["name"] ?? "N/A"}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Owner: ${horse["owner"] ?? "Unknown"}"),
            Text("Sex: ${horse["sex"] ?? "N/A"}"),
            Text("Birth date: ${horse["birth_date"]?.toString() ?? "N/A"}"),
            if (horse["alive"] == false)
              Text("Died: ${horse["death_date"]?.toString() ?? "N/A"} years old"),
            Text("G1 Wins: ${horse["wins_G1"] ?? "N/A"}"),
            Text("G2 Wins: ${horse["wins_G2"] ?? "N/A"}"),
            Text("G3 Wins: ${horse["wins_G3"] ?? "N/A"}"),
            const SizedBox(height: 16),
            Image.asset('images/${horse["image"] ?? "default.png"}'),
            LikeButton(
              isLiked: HorseDetailsPage.isFavorite(horse["id"]),
              onTap: (favorite) async {
                if (!favorite && HorseDetailsPage.box.length >= 10) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("You can have only 10 favorites!")),
                  );
                  return favorite;
                }

                if (favorite) {
                  HorseDetailsPage.removeHorse(horse["id"]);
                }
                else {
                  HorseDetailsPage.addHorse(horse["id"]);
                }
                return !favorite;
              },
            ),
          ],
        ),
      ),
    );
  }
}
