import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tabnav/models/friend.dart';
import 'package:tabnav/models/general.dart';
import 'package:tabnav/models/icn.dart';
import 'package:tabnav/models/insulin.dart';
import 'package:tabnav/reducers/auth_reducers.dart';
import 'package:tabnav/reducers/friends_reducers.dart';
import 'package:tabnav/reducers/insulin_reducers.dart';
import 'package:tabnav/reducers/icns_reducers.dart';
import 'package:tabnav/reducers/generalReducer.dart';

class AppState {
  final List<Insulin> insulins;
  final List<Icn> icns;
  final List<Friend> friends;
  final General general;
  FirebaseUser user;

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  AppState({
    this.insulins = const [],
    this.icns = const [],
    this.friends = const [],
    this.general,
    this.user,
  });

  @override
  String toString() {
    return "AppState( insulins: ${this.insulins.length}, icns: ${this.icns.length}, friends: ${this.friends.length},  user: ${this.user?.displayName})";
  }
}

AppState appStateReducer(AppState state, dynamic action) {
  return AppState(
    insulins: insulinsReducer(state.insulins, action),
    icns: icnsReducer(state.icns, action),
    friends: friendsReducer(state.friends, action),
    user: userReducer(state.user, action),
    general: generalReducer(state.general, action),
  );
}
