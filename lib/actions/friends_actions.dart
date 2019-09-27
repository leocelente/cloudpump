import 'dart:async';

import 'package:tabnav/models/friend.dart';

class FetchFriends {}

class FetchFriendsFailed {}

class FetchFriendsSucceded {
  List<Friend> friends;
  FetchFriendsSucceded(this.friends);
}

class AddFriend {
  Friend friend;
  AddFriend(this.friend);
}

class AddFriendFailed {}

class AddFriendSucceeded {}

class UpdateFriend {
  Friend newFriend;
  UpdateFriend(this.newFriend);
}

class UpdateFriendFailed {}

class UpdateFriendSucceeded {}

class DeleteFriend {
  String key;
  DeleteFriend(this.key);
}

class DeleteFriendFailed {}

class DeleteFriendSucceeded {}

class FetchFriendData {
  Completer completer;
  Friend friend;
  FetchFriendData(this.friend, {this.completer});
}

class FetchFriendDataSucceeded {}

class FetchFriendDataFailed {}

class NextFriendData {
  Friend friend;
  NextFriendData(this.friend);
}
