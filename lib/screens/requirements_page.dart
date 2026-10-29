import 'package:flutter/material.dart';

class RequirementsPage extends StatelessWidget {
  const RequirementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Requirements')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Upload Required Documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildRequirementItem('Resume/CV', 'Pending'),
          _buildRequirementItem('Medical Certificate', 'Pending'),
          _buildRequirementItem('Endorsement Form', 'Pending'),
        ],
      ),
    );
  }
  
  Widget _buildRequirementItem(String name, String status) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text('Status: '),
        trailing: ElevatedButton(
          onPressed: () {},
          child: const Text('Upload'),
        ),
      ),
    );
  }
}
