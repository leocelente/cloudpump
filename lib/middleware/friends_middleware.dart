import 'dart:async';

import 'package:redux_epics/redux_epics.dart';
import 'package:tabnav/actions/friends_actions.dart';
import 'package:tabnav/api/api.dart';
import 'package:tabnav/models/app_state.dart';

final addFriendMiddlewareEpic = TypedEpic<AppState, AddFriend>(_addFriend);
final updateFriendMiddlewareEpic =
    TypedEpic<AppState, UpdateFriend>(_updateFriend);
final deleteFriendMiddlewareEpic =
    TypedEpic<AppState, DeleteFriend>(_deleteFriend);
final fetchFriendData = TypedEpic<AppState, FetchFriendData>(_fetchFriendData);

Stream<dynamic> _addFriend(
    Stream<AddFriend> actions, EpicStore<AppState> store) {
  return actions.asyncMap((action) {
    DatabaseApi api = DatabaseApi(store.state.user.uid);
    return api.add(ApiDataBucket.friends, action.friend).then((_) {
      return new AddFriendSucceeded();
    }).catchError((error) {
      return new AddFriendFailed();
    });
  });
}

Stream<dynamic> _updateFriend(
    Stream<UpdateFriend> actions, EpicStore<AppState> store) {
  return actions.asyncMap((action) {
    DatabaseApi api = DatabaseApi(store.state.user.uid);
    return api.update(ApiDataBucket.friends, action.newFriend).then((_) {
      return new UpdateFriendSucceeded();
    }).catchError((error) {
      return new UpdateFriendFailed();
    });
  });
}

Stream<dynamic> _deleteFriend(
    Stream<DeleteFriend> actions, EpicStore<AppState> store) {
  return actions.asyncMap((action) {
    DatabaseApi api = DatabaseApi(store.state.user.uid);
    return api.delete(ApiDataBucket.friends, action.key).then((_) {
      return new DeleteFriendSucceeded();
    }).catchError((error) {
      return new DeleteFriendFailed();
    });
  });
}

Stream<dynamic> _fetchFriendData(
    Stream<FetchFriendData> actions, EpicStore<AppState> store) {
  return actions.asyncMap((action) {
    DatabaseApi api = DatabaseApi(store.state.user.uid);
    return api.fetchAllData(uid: action.friend.uid).then((data) {
      action.completer.complete(data);
      return new FetchFriendDataSucceeded();
    }).catchError((error) {
      return new FetchFriendDataFailed();
    });
  });
}
