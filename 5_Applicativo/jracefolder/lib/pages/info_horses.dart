import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_provider.dart';

class HorseDetailsPage extends StatelessWidget {

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
          title: Text(horse["name"] ?? "N/A"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: horse["alive"] == false
                ? [
              Text("Owner: ${horse["owner"] ?? "Unknown"}"),
              Text("Sex: ${horse["sex"] ?? "N/A"}"),
              Text("Died: ${horse["age"]?.toString() ?? "N/A"}"),
              Text("G1 Wins: ${horse["wins_G1"] ?? "N/A"}"),
              Text("G2 Wins: ${horse["wins_G2"] ?? "N/A"}"),
              Text("G3 Wins: ${horse["wins_G3"] ?? "N/A"}"),
            ]
                : [
              Text("Owner: ${horse["owner"] ?? "Unknown"}"),
              Text("Sex: ${horse["sex"] ?? "N/A"}"),
              Text("Age: ${horse["age"]?.toString() ?? "N/A"}"),
              Text("G1 Wins: ${horse["wins_G1"] ?? "N/A"}"),
              Text("G2 Wins: ${horse["wins_G2"] ?? "N/A"}"),
              Text("G3 Wins: ${horse["wins_G3"] ?? "N/A"}"),
            ],
          ),
          isThreeLine: true,
        );
      },
    );
  }
}