import 'package:flutter/material.dart';
import 'package:testooo/models/product.dart';
import 'package:testooo/objectbox.dart';
import 'package:testooo/repo/product_repo.dart';
import 'package:testooo/view/login.dart';

import 'objectbox.g.dart';


late ObjectBox gloablObx;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init ObjectBox
  gloablObx = await ObjectBox.create();

  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Login(),
    );
  }
}
