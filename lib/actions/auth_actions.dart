import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class Login {
  Completer completer;
  Login({this.completer});
}

class LoginFailed {}

class LoginSucceded {
  final FirebaseUser user;

  LoginSucceded(this.user);
}

class Logout {}

class LogoutFailed {}

class LogoutSucceeded {}
