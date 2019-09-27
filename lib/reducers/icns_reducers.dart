import 'package:redux/redux.dart';
import 'package:tabnav/actions/icns_actions.dart';
import 'package:tabnav/models/icn.dart';

final icnsReducer = combineReducers<List<Icn>>([
  new TypedReducer<List<Icn>, FetchIcnsSucceeded>(_setIcn),
]);

List<Icn> _setIcn(_, action) {
  return action.icns;
}
