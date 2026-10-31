import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/minimal_theme.dart';
import 'providers/dashboard_provider.dart';
import 'screens/dashboard/home_dashboard.dart';

void main() {
  runApp(const InternshipMonitorApp());
}

class InternshipMonitorApp extends StatelessWidget {
  const InternshipMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: MaterialApp(
        title: 'Internship Application Monitor',
        debugShowCheckedModeBanner: false,
        theme: MinimalTheme.lightTheme,
        home: const HomeDashboard(),
      ),
    );
  }
}
