import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapping/approuter.dart';
import 'package:mapping/const/my_colors.dart';
import 'package:mapping/logic/Auth/phone_auth_cubit.dart';

class LoginscreanView extends StatefulWidget {
  const LoginscreanView({super.key});

  @override
  State<LoginscreanView> createState() => _LoginscreanViewState();
}

class _LoginscreanViewState extends State<LoginscreanView> {
  final GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();
  String? phoneNumber;

  Widget _buildIntroText(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            subtitle,
            style: const TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Text(
              generateCountryFlag() + '+2',
              style: const TextStyle(fontSize: 18, letterSpacing: 2.0),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: MyColors.blue),
              borderRadius: const BorderRadius.all(Radius.circular(6)),
            ),
            child: TextFormField(
              autofocus: true,
              style: const TextStyle(fontSize: 18, letterSpacing: 2.0),
              keyboardType: TextInputType.phone,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Phone number',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                if (value.length < 11) {
                  return 'Phone number must be 11 digits';
                }
                return null;
              },
              onSaved: (value) {
                phoneNumber = value;
              },
            ),
          ),
        ),
      ],
    );
  }

  String generateCountryFlag() {
    const String countryCode = 'eg';
    return countryCode.toUpperCase().replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
    );
  }

  Future<void> _register(BuildContext context) async {
    if (_phoneFormKey.currentState!.validate()) {
      _phoneFormKey.currentState!.save();
      final fullPhoneNumber = "+2$phoneNumber";
      BlocProvider.of<PhoneAuthCubit>(
        context,
      ).submitPhoneNumber(fullPhoneNumber);
    }
  }

  Widget _buildNextButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          _register(context);
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(110, 50),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: const Text(
          'Next',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberSubmit() {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is PhoneAuthLoading) {
          showProgressIndicator(context);
        }
        if (state is PhoneAuthCodeSent) {
          Navigator.pop(context);
          Navigator.pushNamed(
            context,
            Routes.otpscreen,
            arguments: "+20$phoneNumber",
          );
        }
        if (state is PhoneAuthFailure) {
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Container(),
    );
  }

  void showProgressIndicator(BuildContext context) {
    AlertDialog alertDialog = const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ),
    );

    showDialog(
      barrierColor: Colors.white.withOpacity(0),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return alertDialog;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _phoneFormKey,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 88),
            child: Column(
              children: [
                _buildIntroText(
                  'What is your phone number?',
                  'Please enter your phone number to verify your account',
                ),
                const SizedBox(height: 10),
                _buildPhoneNumberField(),
                const SizedBox(height: 70),
                _buildNextButton(context),
                _buildPhoneNumberSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
