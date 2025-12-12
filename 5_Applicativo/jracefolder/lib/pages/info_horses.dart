import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import '../data_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Pagina per mostrare la lista dei cavalli
// Widget con dati presenti che cambiano
class HorseDetailsPage extends StatefulWidget {
  const HorseDetailsPage({super.key});

  static final Box<int> box = Hive.box<int>('favorite_horses');

  // Metodo per prendere i cavalli preferiti
  static List<int> getAll() {
    return box.keys.cast<int>().toList();
  }

  // Controlla se il cavallo fornito è nei preferiti
  static bool isFavorite(int id) {
    return box.containsKey(id);
  }

  // Aggiunge il cavallo fornito ai preferiti se non sono 10
  static void addHorse(int id) {
    if (box.length >= 10) return;
    if (!box.containsKey(id)) {
      box.put(id, id);
    }
  }

  // Rimuove il cavallo fornito dai preferiti
  static void removeHorse(int id) {
    box.delete(id);
  }

  @override
  State<HorseDetailsPage> createState() => _HorsePageSate();
}

// Widget dinamico, cambia quando vinene chiamato setState()
class _HorsePageSate extends State<HorseDetailsPage> {
  List<dynamic> displayData = [];
  List<dynamic> allData = [];
  bool start = true;

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataProvider>(context, listen: false).horses;

    // Ordina i cavalli in ordine alfabetico prioritando i preferiti
    void sortData() {
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

    if (data.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    else {
      if (start) {
        allData = data.toList();
        displayData = data.toList();
        start = false;
      }
      sortData();
    }

    // Ricerca i cavalli in base alla striga fornita (maiuscole irrilevanti)
    // Cambia i dati visualizzati ogni volta che cambia la stringa
    void filterData(String query) {
      setState(() {
        String schQuery = query.toLowerCase();
        displayData = allData.where((horse) => horse["name"].toLowerCase().startsWith(schQuery)).toList();
        if (displayData.isNotEmpty) {
          sortData();
        }
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text("Horses",  style: TextStyle(color: Colors.white),), backgroundColor:  Color(0xFF149109),),
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
              onChanged: (value) => filterData(value),
            ),
          ),
          Expanded(
            child: displayData.isEmpty ?
                const Center(
                  child: Text(
                    "No horse found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                )
            : ListView.builder(
                itemCount: displayData.length,
                itemBuilder: (context, index) {
                  final horse = displayData[index];
                  return Card(
                  child: ListTile(
                      title: Text(horse["name"] ?? "N/A", style: TextStyle(color: HorseDetailsPage.isFavorite(horse["id"]) ?
                      Color(0xFFD50303) :  Color(0xFF000000)),),
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

// Pagina per mostrare le informazioni su un cavallo
class HorseDetailPage extends StatelessWidget {
  const HorseDetailPage({super.key, required this.horse});

  // Mappa per i colori
  final Map<String, Color> colorMap = const {
    'g1': Color(0xFFFFD700),
    'g2': Color(0xFFC0C0C0),
    'g3': Color(0xFFCD7F32)
  };

  final Map<String, dynamic> horse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(horse["name"] ?? "Horse Detail")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;

          bool snackBarActive = false;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isWide
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/${horse["image"] ?? "default.png"}',
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/images/default.png');
                          },
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                )
                    : Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/${horse["image"] ?? "default.png"}',
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/default.png",
                            height: 250,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text(
                  "Wins",
                  style: TextStyle(
                    fontSize: isWide ? 26 : 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF149109),
                  ),
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  children: [
                    _statBadge("G1", horse["wins_G1"], "g1"),
                    _statBadge("G2", horse["wins_G2"], "g2"),
                    _statBadge("G3", horse["wins_G3"], "g3"),
                  ],
                ),

                const SizedBox(height: 24),

                Center(
                  child: LikeButton(
                    isLiked: HorseDetailsPage.isFavorite(horse["id"]),
                    onTap: (fav) async {
                      if (!fav && HorseDetailsPage.box.length >= 10) {
                        if (!snackBarActive) {
                          snackBarActive = true;
                          final messenger = ScaffoldMessenger.of(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("You can have only 10 favorites!")),
                          ).closed.then((_) {
                            snackBarActive = false;
                          });
                        }
                        return fav;
                      }
                      // Controllo notifiche, programmate non funzionanti
                      //NotiService().showNotifications(title: "Notice", body: "Added horse to favorites");
                      //NotiService().scheduleNotification(id: 2, title: "Reminder", body: "You added a new favorite horse 2", hour: 9, minute:32);
                      if (fav) {
                        HorseDetailsPage.removeHorse(horse["id"]);
                        //NotiService().scheduleNotification(id: 1000, title: "Reminder", body: "You added a new favorite horse 1", hour: 2, minute: 09);
                      }
                      else {
                        HorseDetailsPage.addHorse(horse["id"]);
                        //NotiService().scheduleNotification(id: 20111, title: "Reminder", body: "You added a new favorite horse 1", hour: 14, minute: 09);
                      }
                      return !fav;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoCard(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              horse["name"] ?? "N/A",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF149109),
              ),
            ),
            const SizedBox(height: 8),
            Text("Owner: ${horse["owner"] ?? "Unknown"}"),
            Text("Trainer: ${horse["trainer"]  ?? "N/A"}"),
            Text("Sex: ${horse["sex"] ?? "N/A"}"),
            Text("Birth date: ${horse["birth_date"] ?? "N/A"}"),
            if (horse["alive"] == false)
              Text("Died: ${horse["death_date"] ?? "N/A"}"),
            Text("Sire: ${horse["sire"]  ?? "N/A"}"),
            Text("Dam: ${horse["dam"]  ?? "N/A"}"),
            Text("Breeder: ${horse["breeder"]  ?? "N/A"}"),
            Text("Earnings: ${horse["earnings_jpy"]  ?? "N/A"}"),

            const SizedBox(height: 12),

            // Major victories
            if (horse["major_victories"] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Major Victories:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  for (var victory in horse["major_victories"])
                    Text("- $victory"),
                ],
              ),

            const SizedBox(height: 8),

            // Titles and awards
            if (horse["titles_and_awards"] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Titles & Awards:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  for (var title in horse["titles_and_awards"])
                    Text("- $title"),
                ],
              ),
          ],
        ),
      ),
    );
  }


  Widget _statBadge(String title, dynamic value, String color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: colorMap[color],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title,
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text("${value ?? "-"}", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
