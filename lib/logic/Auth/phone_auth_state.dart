part of 'phone_auth_cubit.dart';

@immutable
sealed class PhoneAuthState {}

final class PhoneAuthInitial extends PhoneAuthState {}

final class PhoneAuthLoading extends PhoneAuthState {}

final class PhoneAuthSuccess extends PhoneAuthState {}

final class PhoneAuthCodeSent extends PhoneAuthState {
  final String verificationId;
  PhoneAuthCodeSent(this.verificationId);
}

final class PhoneAuthCodeVerified extends PhoneAuthState {
  final String verificationId;
  PhoneAuthCodeVerified(this.verificationId);
}

final class PhoneAuthCodeFailed extends PhoneAuthState {
  final String verificationId;
  PhoneAuthCodeFailed(this.verificationId);
}

final class PhoneAuthFailure extends PhoneAuthState {
  final String message;
  PhoneAuthFailure(this.message);
}
