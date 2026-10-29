import 'package:flutter/material.dart';

class CoordinatorReviewPanel extends StatelessWidget {
  const CoordinatorReviewPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coordinator Review Panel')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Stalled Applications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Card(
            child: ListTile(
              title: const Text('Student: 12345'),
              subtitle: const Text('Stalled for 6 days - Pending Review'),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text('Approve Endorsement'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
