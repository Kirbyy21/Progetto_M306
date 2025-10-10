import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:jracefolder/main.dart'; // dove c'è MainPage
import 'package:jracefolder/data_provider.dart';

void main() {
  testWidgets('MainPage loads and shows BottomNavigationBar', (WidgetTester tester) async {
    final dataProvider = DataProvider();

    await dataProvider.fetchData();

    await tester.pumpWidget(
      ChangeNotifierProvider<DataProvider>.value(
        value: dataProvider,
        child: MaterialApp(
          home: MyApp(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });
}
