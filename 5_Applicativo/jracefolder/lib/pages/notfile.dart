// lib/pages/notification_test_page.dart
import 'package:flutter/material.dart';
import '../notificationservice.dart'; // o NotiService se è il tuo file

class NotificationTestPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  NotificationTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bum")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Demo Notifications"),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Title",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: bodyController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Description",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                NotificationService().showNotification(
                  1,
                  titleController.text,
                  bodyController.text,
                );
              },
              child: const Text("Show Notification (2 sec)"),
            ),
          ],
        ),
      ),
    );
  }
}
