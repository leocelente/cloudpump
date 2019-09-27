import 'package:redux/redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tabnav/actions/auth_actions.dart';

final userReducer = combineReducers<FirebaseUser>([
  new TypedReducer<FirebaseUser, LoginSucceded>(_setUser),
  new TypedReducer<FirebaseUser, LogoutSucceeded>(_logout),
]);

FirebaseUser _setUser(_, action) {
  return action.user;
}

FirebaseUser _logout(_, __) {
  return null;
}