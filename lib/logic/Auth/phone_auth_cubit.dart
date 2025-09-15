// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  late String verificationId;
  final FirebaseAuth firebaseAuth;

  PhoneAuthCubit({FirebaseAuth? firebaseAuth})
    : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      super(PhoneAuthInitial());

  Future<void> submitPhoneNumber(String phoneNumber) async {
    emit(PhoneAuthLoading());
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+2$phoneNumber',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await firebaseAuth.signInWithCredential(credential);
          emit(PhoneAuthSuccess());
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(PhoneAuthFailure(e.message.toString()));
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;
          emit(PhoneAuthCodeSent(verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
          emit(PhoneAuthCodeSent(verificationId));
        },
      );
    } catch (e) {
      emit(PhoneAuthFailure(e.toString()));
    }
  }

  Future<void> verifyCode(String code) async {
    emit(PhoneAuthLoading());
    try {
      await firebaseAuth.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: code,
        ),
      );
      emit(PhoneAuthSuccess());
    } catch (e) {
      emit(PhoneAuthFailure(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(PhoneAuthLoading());
    try {
      await firebaseAuth.signOut();
      emit(PhoneAuthInitial());
    } catch (e) {
      emit(PhoneAuthFailure(e.toString()));
    }
  }

  User? getLoggedInUser() {
    return firebaseAuth.currentUser;
  }
}
