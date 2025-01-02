import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testooo/app.dart';
import 'package:testooo/controller/product_provider.dart';
import 'package:testooo/models/product.dart';
import 'package:testooo/models/transaction/transaction_repo.dart';
import 'package:testooo/objectbox.dart';
import 'package:testooo/order/active_order_repo.dart';
import 'package:testooo/orderLine/order_line_repo.dart';
import 'package:testooo/provider/cart_manager.dart';
import 'package:testooo/provider/cart_provider.dart';
import 'package:testooo/repo/product_repo.dart';
import 'package:testooo/shared/setup_check.dart';
import 'package:testooo/view/login.dart';
import 'package:testooo/view/product_screen.dart';

import 'objectbox.g.dart';

/// Global SharedPreferences instance
late final SharedPreferences prefs;

/// Global PosConfigPrefs instance
late final SetupCheck setupPrefs;
late ObjectBox gloablObx;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize ObjectBox
  gloablObx = await ObjectBox.create();

  // Initialize Preferences
  prefs = await SharedPreferences.getInstance();

  // Initialize PosConfigPrefs
  setupPrefs = SetupCheck(prefs: prefs);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => CartProvider(
                activeOrderBox: ActiveOrderRepo(gloablObx.store.box()),
                orderLineRepo: OrderLineRepo(gloablObx.store.box()))),
        ChangeNotifierProvider(
            create: (_) => CartManager(),),
      ],
      child: const App(),
    ),
  );
}
