import 'dart:async';

import 'package:redux_epics/redux_epics.dart';
import 'package:tabnav/actions/insulin_actions.dart';
import 'package:tabnav/api/api.dart';
import 'package:tabnav/models/app_state.dart';

final addInsulinMiddlewareEpic = TypedEpic<AppState, AddInsulin>(_addInsulin);
final updateInsulinMiddlewareEpic =
    TypedEpic<AppState, UpdateInsulin>(_updateInsulin);
final deleteInsulinMiddlewareEpic =
    TypedEpic<AppState, DeleteInsulin>(_deleteInsulin);

Stream<dynamic> _addInsulin(
    Stream<AddInsulin> actions, EpicStore<AppState> store) {
  return actions.asyncMap((action) {
    DatabaseApi api = DatabaseApi(store.state.user.uid);
    return api.add(ApiDataBucket.insulins, action.insulin).then((_) {
      action.completer.complete(null);
      return new AddInsulinSucceeded();
    }).catchError((error) {
      return new AddInsulinFailed();
    });
  });
}

Stream<dynamic> _updateInsulin(
    Stream<UpdateInsulin> actions, EpicStore<AppState> store) {
  return actions.asyncMap((action) {
    DatabaseApi api = DatabaseApi(store.state.user.uid);
    return api.update(ApiDataBucket.insulins, action.newInsulin).then((_) {
      return new UpdateInsulinSucceeded();
    }).catchError((error) {
      return new UpdateInsulinFailed();
    });
  });
}

Stream<dynamic> _deleteInsulin(
    Stream<DeleteInsulin> actions, EpicStore<AppState> store) {
  return actions.asyncMap((action) {
    DatabaseApi api = DatabaseApi(store.state.user.uid);
    return api.delete(ApiDataBucket.insulins, action.key).then((_) {
      return new DeleteInsulinSucceeded();
    }).catchError((error) {
      return new DeleteInsulinFailed();
    });
  });
}
