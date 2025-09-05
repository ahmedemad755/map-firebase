import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'approuter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MainApp(appRouter: Approuter()));
}

class MainApp extends StatelessWidget {
  final Approuter appRouter;
  const MainApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.ongenerateRoute,
    );
  }
}
