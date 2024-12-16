import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testooo/app.dart';
import 'package:testooo/controller/product_provider.dart';
import 'package:testooo/models/product.dart';
import 'package:testooo/objectbox.dart';
import 'package:testooo/repo/product_repo.dart';
import 'package:testooo/shared/setup_check.dart';
import 'package:testooo/view/login.dart';
import 'package:testooo/view/product_screen.dart';

import 'objectbox.g.dart';


late ObjectBox gloablObx;


/// Global SharedPreferences instance
late final SharedPreferences prefs;

/// Global PosConfigPrefs instance
late final SetupCheck setupPrefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init ObjectBox
  gloablObx = await ObjectBox.create();

  
  // Initialize Preferences
  prefs = await SharedPreferences.getInstance();

  // Initialize PosConfigPrefs
  setupPrefs = SetupCheck(prefs: prefs);

  runApp(const App());
}
