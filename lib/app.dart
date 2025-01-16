// import 'package:base_pos/main.dart';
// import 'package:base_pos/screens/second_screen.dart';
// import 'package:base_pos/setup/setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:testooo/main.dart';
import 'package:testooo/routes/app_routes.dart';
import 'package:testooo/routes/routes_generator.dart';
import 'package:testooo/setup/setup_screen.dart';
import 'package:testooo/view/login.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'POS App',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      onGenerateRoute: RoutesGenerator.generateRoute,
      // showPerformanceOverlay: true,
      // showSemanticsDebugger: true,
    );
  }
}
