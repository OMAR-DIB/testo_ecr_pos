// import 'package:base_pos/screens/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testooo/routes/app_routes.dart';


class SetupCheck {
  final SharedPreferences _prefs;

  SetupCheck({required SharedPreferences prefs}) : _prefs = prefs;

  bool isSetupComplete() {
    // final prefs = await SharedPreferences.getInstance();

    // Check if both terminal ID and ECR serial are saved
    String? terminalId = _prefs.getString('terminal_id');
    String? ecrSerial = _prefs.getString('ecr_serial');

    return terminalId != null &&
        ecrSerial != null &&
        terminalId.isNotEmpty &&
        ecrSerial.isNotEmpty;
  }

  void login(BuildContext context, String email, String password) {
    if (email == "omar@gmail.com" && password == "123") {
      _prefs.setBool('isLoggedIn', true);
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => ProductScreen()),
      // );
      Navigator.pushReplacementNamed(context,
            AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
        ),
      );
    }
  }
}