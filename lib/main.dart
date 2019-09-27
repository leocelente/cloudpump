import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:redux_logging/redux_logging.dart';

import 'package:tabnav/middleware/auth_middleware.dart';
import 'package:tabnav/middleware/insulins_middleware.dart';
import 'package:tabnav/middleware/icns_middleware.dart';
import 'package:tabnav/middleware/friends_middleware.dart';
import 'package:tabnav/models/app_state.dart';

import 'package:tabnav/general/constants.dart';
import 'package:tabnav/ui/pages/icns/icns.dart';
import 'package:tabnav/ui/widgets/app.dart';
import 'package:tabnav/ui/pages/general/account.dart';
import 'package:tabnav/middleware/middleware.dart';

Future<void> main() async {
  final FirebaseApp _ =
      await FirebaseApp.configure(name: 'db2', options: fbOptions);
  FirebaseDatabase.instance.setPersistenceCacheSizeBytes(1000000);
  FirebaseDatabase.instance.setPersistenceEnabled(true);

  // FirebaseDatabase.instance.setPersistenceEnabled(false);
  return runApp(MyApp());
}

final epics = combineEpics<AppState>([
  addInsulinMiddlewareEpic,
  updateInsulinMiddlewareEpic,
  deleteInsulinMiddlewareEpic,
  addFriendMiddlewareEpic,
  updateFriendMiddlewareEpic,
  deleteFriendMiddlewareEpic,
  addIcnMiddlewareEpic,
  updateIcnMiddlewareEpic,
  deleteIcnMiddlewareEpic,
  loginMiddlewareEpic,
  logoutMiddlewareEpic,
  afterLoginMiddlewareEpic,
  fetchFriendData
]);

class MyApp extends StatelessWidget {
  final store = Store<AppState>(appStateReducer,
      initialState: AppState(),
      middleware: [
        EpicMiddleware(epics),
        LoggingMiddleware.printer(),
        fetchAllMidleware
      ]);
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
         debugShowCheckedModeBanner: false,
        // showPerformanceOverlay: true,
        title: appName,
        theme: ThemeData(
          primaryColor: Colors.blueGrey[800],
          accentColor: Colors.orange[500],
          // backgroundColor: Colors.grey[300],
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => RootApp(),
          '/account': (context) => AccountPage(),
          '/pump': (context) => IcnPage(),
        },
      ),
    );
  }
}
