import 'package:flutter/material.dart';
import 'package:mapping/presentation/views/loginscrean_view.dart';

class Routes {
  static const String loginscrean = '/';
}

class Approuter {
  Route? ongenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginscrean:
        return MaterialPageRoute(builder: (_) => LoginscreanView());
    }
    return null;
  }
}
