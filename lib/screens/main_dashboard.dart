import 'package:flutter/material.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const LinearProgressIndicator(value: 0.4),
            const SizedBox(height: 8),
            const Text('Step 2 of 5: Adviser Endorsement'),
            const SizedBox(height: 24),
            const Text('Urgent Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Card(
              child: ListTile(
                leading: Icon(Icons.warning, color: Colors.orange),
                title: Text('Application needs attention'),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/requirements'), child: const Text('Requirements')),
                ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/coordinator'), child: const Text('Coordinator Review')),
                ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/status'), child: const Text('Status & Placement')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
