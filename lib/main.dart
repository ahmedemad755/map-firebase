import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapping/app_router.dart';
import 'package:mapping/service/custom_bloc_observer.dart';

late String initialRoute;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = CustomBlocObserver();
  await Firebase.initializeApp();

  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user != null) {
      initialRoute = Routes.loginscrean;
    } else {
      initialRoute = Routes.map;
    }
  });
  runApp(MyApp(appRouter: Approuter()));
}

class MyApp extends StatelessWidget {
  final Approuter appRouter;

  const MyApp({Key? key, required this.appRouter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      onGenerateRoute: appRouter.ongenerateRoute,
      initialRoute: initialRoute,
    );
  }
}
