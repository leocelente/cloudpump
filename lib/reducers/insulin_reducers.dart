import 'package:redux/redux.dart';
import 'package:tabnav/actions/insulin_actions.dart';
import 'package:tabnav/models/insulin.dart';

final insulinsReducer = combineReducers<List<Insulin>>([
  new TypedReducer<List<Insulin>, FetchInsulinsSucceeded>(_setInsulin),
]);

List<Insulin> _setInsulin(_, action) {
  List<Insulin> i = List.from(action.insulins);
  // i.sort((a, b) {
  //   return b.time.compareTo(a.time);
  // });
  return i.toList();
}
