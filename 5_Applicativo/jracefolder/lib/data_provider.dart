import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Provider  gestisce il caricamento dei dati da un JSON esterno
class DataProvider extends ChangeNotifier {
  List<dynamic> horses = [];
  List<dynamic> races = [];
  List<dynamic> results = [];

  // Controlla che race e horses non siano vuote
  // Ritorna true e mostra la UI solo se i dati sono caricati
  bool get isLoaded => horses.isNotEmpty && races.isNotEmpty;

  // Prende i dati da un link di un file JSON
  Future<void> fetchData() async {
    // URL https://jsonkeeper.com/b/F5TB0
    //("https://jsonkeeper.com/b/KULPG");
    final url = Uri.parse("https://jsonkeeper.com/b/F5TB0");
    // Aspetta una risposta dal URL
    final response = await http.get(url);
    // Prende i dati dal JSON in una Map
    final Map<String, dynamic> decoded = jsonDecode(response.body);
    // Enstrae i dati nelle liste assegnate
    horses = decoded['horses'] ?? [];
    races = decoded['races'] ?? [];
    results = decoded['results'] ?? [];

    // Notifica i widget in ascolto del cambiamento
    notifyListeners();
  }
}
