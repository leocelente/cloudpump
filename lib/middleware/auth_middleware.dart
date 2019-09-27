import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:tabnav/actions/auth_actions.dart';
import 'package:tabnav/api/api.dart';
import 'package:tabnav/middleware/middleware.dart';
import 'package:tabnav/models/app_state.dart';

final loginMiddlewareEpic = new TypedEpic<AppState, Login>(_login);
final logoutMiddlewareEpic = new TypedEpic<AppState, Logout>(_logout);
final afterLoginMiddlewareEpic =
    new TypedEpic<AppState, LoginSucceded>(_afterLoginFetchALl);


Stream<dynamic> _login(Stream<Login> actions, EpicStore<AppState> store) {
  return actions.asyncMap((action) {
    AuthApi api = new AuthApi();
    return api.signIn().then((FirebaseUser user) {
      return LoginSucceded(user);
    }).catchError((error) {
      return LoginFailed();
    });
  });
}

Stream<dynamic> _logout(Stream<Logout> actions, EpicStore<AppState> store) {
  return actions.asyncMap((action) {
    AuthApi api = new AuthApi();
    return api.signOut().then((_) {
      return LogoutSucceeded();
    }).catchError((err) {
      return LogoutFailed();
    });
  });
}

Stream<dynamic> _afterLoginFetchALl(
    Stream<LoginSucceded> actions, EpicStore<AppState> store) {
  return actions.asyncMap((_) {
    return FetchAll();
  });
}
