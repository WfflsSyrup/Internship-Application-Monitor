import 'package:flutter/material.dart';

import 'screens/main_dashboard.dart';

void main() {
  runApp(const InternshipMonitorApp());
}

class InternshipMonitorApp extends StatelessWidget {
  const InternshipMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Internship Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3157C8)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const MainDashboard(),
    );
  }
}
