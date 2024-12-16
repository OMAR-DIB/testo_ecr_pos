// import 'package:base_pos/screens/second_screen.dart';
// import 'package:base_pos/setup/setup_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testooo/setup/setup_controller.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    final formKey = GlobalKey<FormState>();
    final terminalid = TextEditingController();
    final ECR = TextEditingController();
    return ChangeNotifierProvider(
      create: (context) => SetupController(),
      builder: (context, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Setup"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: ECR,
                  decoration: InputDecoration(
                    labelText: "ECR serial Number",
                    hintText: "Enter ECR serial Number",
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a serial Number.";
                    }
                    if (value.length != 14 || int.tryParse(value) == null) {
                      return "Enter a valid serial Number of 14 digits.";
                    }
                    return null; // Validation passed
                  },
                ),
                TextFormField(
                  controller: terminalid,
                  decoration: InputDecoration(
                    labelText: "Terminal ID",
                    hintText: "Enter terminal ID",
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a terminal ID.";
                    }
                    return null; // Validation passed
                  },
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                         SetupController.saveSetupInfo(context: context, formKey: formKey, terminalIdController: terminalid, ECRController: ECR);
                      }else {
                        
                      }
                    },
                    child: Text("submit")),
              ],
            ),
          ),
        ),
      );
      },
    );
  }
}
