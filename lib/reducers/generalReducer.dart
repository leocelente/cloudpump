import 'package:redux/redux.dart';
import 'package:tabnav/actions/general_actions.dart';
import 'package:tabnav/models/general.dart';

final generalReducer = combineReducers<General>([
  new TypedReducer<General, SetTabIndex>(_setIndex),
]);

General _setIndex(_, action) {
  return new General(action.index);
}
