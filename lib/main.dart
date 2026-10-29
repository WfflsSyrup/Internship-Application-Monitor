import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/main_dashboard.dart';
import 'screens/requirements_page.dart';
import 'screens/coordinator_review_panel.dart';
import 'screens/status_placement_page.dart';

void main() {
  runApp(const InternshipMonitorApp());
}

class InternshipMonitorApp extends StatelessWidget {
  const InternshipMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Internship Application Monitor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const MainDashboard(),
        '/requirements': (context) => const RequirementsPage(),
        '/coordinator': (context) => const CoordinatorReviewPanel(),
        '/status': (context) => const StatusPlacementPage(),
      },
    );
  }
}
