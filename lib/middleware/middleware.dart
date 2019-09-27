import 'package:firebase_database/firebase_database.dart';
import 'package:redux/redux.dart';
import 'package:tabnav/actions/friends_actions.dart';
import 'package:tabnav/actions/icns_actions.dart';
import 'package:tabnav/actions/insulin_actions.dart';
import 'package:tabnav/models/app_state.dart';
import 'package:tabnav/models/friend.dart';
import 'package:tabnav/models/icn.dart';
import 'package:tabnav/models/insulin.dart';

class FetchAll {}

class SetupListeners {}

void fetchAllMidleware(Store<AppState> store, action, NextDispatcher next) {
  // If our Middleware encounters a `FetchTodoAction`
  if (action is FetchAll) {
    var iRef = FirebaseDatabase.instance
        .reference()
        .child("users/${store.state.user.uid}/insulins");
    var fRef = FirebaseDatabase.instance
        .reference()
        .child("users/${store.state.user.uid}/friends");
    var sRef = FirebaseDatabase.instance
        .reference()
        .child("users/${store.state.user.uid}/icns");

    iRef.onValue.listen((Event e) {
      var data = e.snapshot.value;
      List<Insulin> i = Insulin.parseList(data);
      print(i.length);
      i = i.where(testTime).toList();
      print(i.length);
      store.dispatch(new FetchInsulinsSucceeded(i));
    });
    fRef.onValue.listen((Event e) {
      var data = e.snapshot.value;
      List<Friend> f = Friend.parseList(data);
      store.dispatch(new FetchFriendsSucceded(f));
    });
    sRef.onValue.listen((Event e) {
      var data = e.snapshot.value;
      List<Icn> s = Icn.parseList(data);
      store.dispatch(new FetchIcnsSucceeded(s));
    });
  }
  next(action);
}

bool testTime(Insulin insulin) {
  return insulin.time.millisecondsSinceEpoch >
      DateTime.now().millisecondsSinceEpoch - 1000 * 60 * 60 * 24 * 7;
}
