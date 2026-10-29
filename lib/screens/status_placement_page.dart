import 'package:flutter/material.dart';

class StatusPlacementPage extends StatelessWidget {
  const StatusPlacementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Status & Placement')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Current Stage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('Partner Submission'),
            const SizedBox(height: 16),
            const Text('Interviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Card(child: ListTile(title: Text('No interviews scheduled'))),
            const SizedBox(height: 16),
            const Text('Placement Offer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Card(child: ListTile(title: Text('Pending'))),
          ],
        ),
      ),
    );
  }
}
