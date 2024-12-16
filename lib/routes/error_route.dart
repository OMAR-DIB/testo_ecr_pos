import 'package:flutter/material.dart';

Route<dynamic> errorRoute(RouteSettings settings) {
  return MaterialPageRoute(
    builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          centerTitle: true,
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning,
                size: 50,
              ),
              Text(
                "ERROR! No route defined for '${settings.name}'.",
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}