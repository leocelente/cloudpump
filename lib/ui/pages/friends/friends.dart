import 'package:flutter/material.dart';
import 'package:tabnav/ui/pages/friends/add_friend.dart';
import 'package:tabnav/ui/widgets/friends_list.dart';

class FriendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Container(
          child: Flex(
            direction: Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(child: Card(child: FriendsList(), elevation: 5.0,)),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(new MaterialPageRoute<void>(
                builder: (BuildContext context) => AddFriendPage()));
          },
        ),
      ),
    );
  }
}
