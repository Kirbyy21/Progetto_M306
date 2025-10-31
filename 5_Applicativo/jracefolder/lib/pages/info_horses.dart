import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import '../data_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HorseDetailsPage extends StatefulWidget {
  const HorseDetailsPage({ super.key});

  static final Box<int> box = Hive.box<int>('favorite_horses');

  static List<int> getAll() {
    return box.keys.cast<int>().toList();
  }

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

  @override
  State<HorseDetailsPage> createState() => _HorsePageSate();
}

class _HorsePageSate extends State<HorseDetailsPage> {
  List<dynamic> displayData = [];

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataProvider>(context, listen: false).horses;
    if (data.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    else {
      data.sort((a, b) {
        final aFav = HorseDetailsPage.isFavorite(a["id"]);
        final bFav = HorseDetailsPage.isFavorite(b["id"]);

        if (aFav && !bFav) return -1;
        if (!aFav && bFav) return 1;

        return a["name"].compareTo(b["name"]);
      });
    }

    void _sortData() {
      setState(() {
        displayData.sort((a, b) {
          final aFav = HorseDetailsPage.isFavorite(a["id"]);
          final bFav = HorseDetailsPage.isFavorite(b["id"]);

          if (aFav && !bFav) return -1;
          if (!aFav && bFav) return 1;

          return a["name"].compareTo(b["name"]);
        });
      });
    }

    void _filterData(String query) {
      setState(() {
        String schQuery = query.toLowerCase();
        displayData = data.where((horse) => horse["name"].toLowerCase().startsWith(schQuery)).toList();
        if (displayData.isEmpty) {
          displayData.add({"name": "No horse found"});
        }
        _sortData();
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text("Horses",  style: TextStyle(color: Colors.white),), backgroundColor: Colors.blueAccent,),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search a horse...",
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) => _filterData(value),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: (displayData.isNotEmpty ? displayData : data).length,
                itemBuilder: (context, index) {
                  final horse = (displayData.isNotEmpty ? displayData : data)[index];
                return Card(
                  child: ListTile(
                      title: Text(horse["name"] ?? "N/A", style: TextStyle(color: HorseDetailsPage.isFavorite(horse["id"]) ? Colors.redAccent : Colors.blue),),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HorseDetailPage(horse: horse),
                        ),
                      ).then((_) {
                        setState(() {
                        });
                      });
                    }
                  ),
                );
              }
            )
          ),
        ],
      ),
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
            Image.asset('images/${horse["image"] ?? "images/default.png"}',
            errorBuilder: (context, error, stackTrace) {
              return Image.asset("images/default.png");
            }
              ,),
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
