
import 'package:flutter/material.dart';
import 'package:testooo/routes/app_routes.dart';
import 'package:testooo/routes/error_route.dart';
import 'package:testooo/setup/setup_screen.dart';
import 'package:testooo/view/login.dart';
import 'package:testooo/view/product_screen.dart';
import 'package:testooo/view/show_product.dart';

class RoutesGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // access the arguments
    // final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.setup:
        return MaterialPageRoute(builder: (_) => const SetupScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const Login());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const ProductScreen());
      case AppRoutes.showProduct:
        return MaterialPageRoute(builder: (_) => const ShowProduct());
    }

    return errorRoute(settings);
  }
}
