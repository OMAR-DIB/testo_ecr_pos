
// Provider class for managing setup information
// import 'package:base_pos/screens/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testooo/routes/app_routes.dart';
import 'package:testooo/view/login.dart';

class SetupController extends ChangeNotifier {

  static Future<void> saveSetupInfo({
    required BuildContext context, 
    required GlobalKey<FormState> formKey, 
    required TextEditingController terminalIdController,
    required TextEditingController ECRController
  }) async {
    if (formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('terminal_id', terminalIdController.text);
      await prefs.setString('ecr_serial', ECRController.text);

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => Login(),
      //   ),
      // );
      Navigator.pushReplacementNamed(context,
            AppRoutes.login);
    }
  }

  // // Method to check if setup is complete
  // Future<bool> isSetupComplete() async {
  //   final prefs = await SharedPreferences.getInstance();
    
  //   String? terminalId = prefs.getString('terminal_id');
  //   String? ecrSerial = prefs.getString('ecr_serial');
    
  //   return terminalId != null && 
  //          ecrSerial != null && 
  //          terminalId.isNotEmpty && 
  //          ecrSerial.isNotEmpty;
  // }
}
