import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataProvider extends ChangeNotifier {
  List<dynamic> horses = [];
  List<dynamic> races = [];
  List<dynamic> results = [];

  bool get isLoaded => horses.isNotEmpty && races.isNotEmpty;

  Future<void> fetchData() async {
    final url = Uri.parse("https://www.jsonkeeper.com/b/2CSEQ");
    final response = await http.get(url);
    final Map<String, dynamic> decoded = jsonDecode(response.body);
    horses = decoded['horses'] ?? [];
    races = decoded['races'] ?? [];
    results = decoded['results'] ?? [];
    notifyListeners();
  }
}
