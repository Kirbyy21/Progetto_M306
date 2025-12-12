import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Classe che prende i dati da un JSON esterno
class DataProvider extends ChangeNotifier {
  List<dynamic> horses = [];
  List<dynamic> races = [];
  List<dynamic> results = [];

  bool get isLoaded => horses.isNotEmpty && races.isNotEmpty;

  // Prende i dati da un link di un file JSON
  Future<void> fetchData() async {
    final url = Uri.parse("https://jsonkeeper.com/b/KULPG");
    final response = await http.get(url);
    final Map<String, dynamic> decoded = jsonDecode(response.body);
    horses = decoded['horses'] ?? [];
    races = decoded['races'] ?? [];
    results = decoded['results'] ?? [];
    notifyListeners();
  }
}
