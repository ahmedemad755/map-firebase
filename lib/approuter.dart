import 'package:flutter/material.dart';
import 'package:mapping/logic/Auth/phone_auth_cubit.dart';
import 'package:mapping/presentation/views/loginscrean_view.dart';
import 'package:mapping/presentation/views/map_screan.dart';
import 'package:mapping/presentation/views/otp_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Routes {
  static const String loginscrean = '/';
  static const String otpscreen = 'otp-screen';
  static const String map = 'map';
}

class Approuter {
  PhoneAuthCubit? phoneAuthCubit;

  Approuter() {
    phoneAuthCubit = PhoneAuthCubit();
  }

  Route? ongenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginscrean:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: LoginscreanView(),
          ),
        );
      case Routes.otpscreen:
        final fullPhoneNumber = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: OtpScreen(phoneNumber: fullPhoneNumber),
          ),
        );
      case Routes.map:
        return MaterialPageRoute(builder: (_) => MapScrean());
    }
    return null;
  }
}
