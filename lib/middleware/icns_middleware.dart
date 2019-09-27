import 'dart:async';

import 'package:redux_epics/redux_epics.dart';
import 'package:tabnav/actions/icns_actions.dart';
import 'package:tabnav/api/api.dart';
import 'package:tabnav/models/app_state.dart';

final addIcnMiddlewareEpic = TypedEpic<AppState, AddIcn>(_addIcn);
final updateIcnMiddlewareEpic = TypedEpic<AppState, UpdateIcn>(_updateIcn);
final deleteIcnMiddlewareEpic = TypedEpic<AppState, DeleteIcn>(_deleteIcn);

Stream<dynamic> _addIcn(Stream<AddIcn> actions, EpicStore<AppState> store) {
  return actions.asyncMap((action) {
    DatabaseApi api = DatabaseApi(store.state.user.uid);
    return api.add(ApiDataBucket.sensitivity, action.icn).then((_) {
      return new AddIcnSucceeded();
    }).catchError((error) {
      return new AddIcnFailed();
    });
  });
}

Stream<dynamic> _updateIcn(
    Stream<UpdateIcn> actions, EpicStore<AppState> store) {
  return actions.asyncMap((action) {
    DatabaseApi api = DatabaseApi(store.state.user.uid);
    return api.update(ApiDataBucket.sensitivity, action.newIcn).then((_) {
      return new UpdateIcnSucceeded();
    }).catchError((error) {
      return new UpdateIcnFailed();
    });
  });
}

Stream<dynamic> _deleteIcn(
    Stream<DeleteIcn> actions, EpicStore<AppState> store) {
  return actions.asyncMap((action) {
    DatabaseApi api = DatabaseApi(store.state.user.uid);
    return api.delete(ApiDataBucket.sensitivity, action.key).then((_) {
      return new DeleteIcnSucceeded();
    }).catchError((error) {
      return new DeleteIcnFailed();
    });
  });
}
