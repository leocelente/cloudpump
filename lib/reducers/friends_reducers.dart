import 'package:redux/redux.dart';
import 'package:tabnav/actions/friends_actions.dart';
import 'package:tabnav/models/friend.dart';

final friendsReducer = combineReducers<List<Friend>>([
  new TypedReducer<List<Friend>, FetchFriendsSucceded>(_setFriend),
]);

List<Friend> _setFriend(_, action) {
  return action.friends;
}
