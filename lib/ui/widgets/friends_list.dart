import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tabnav/actions/friends_actions.dart';
import 'package:tabnav/models/app_state.dart';
import 'package:tabnav/models/friend.dart';
import 'package:tabnav/ui/pages/friends/single_friend.dart';

class FriendsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StoreBuilder(
        onDispose: (Store<AppState> store) {},
        builder: (context, Store<AppState> store) {
          if (store.state.friends.length == 0) {
            return Center(
              child: CircularProgressIndicator(
                value: null,
              ),
            );
          } else
            return ListView.builder(
              shrinkWrap: true,
              itemCount: store.state.friends.length ?? 0,
              itemBuilder: (context, index) {
                final Friend i = store.state.friends[index];
                return ListTile(
                  trailing: Icon(Icons.remove_red_eye),
                  onLongPress: () => showModalBottomSheet(
                      builder: (builder) {
                        return Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.edit),
                                title: const Text("Edit"),
                                onTap: () {
                                  // Navigator.of(context).push(
                                  //     new MaterialPageRoute<void>(
                                  //         builder: (BuildContext context) =>
                                  //             AddInsulinPage(editInsulin: i,)));
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.delete_forever),
                                title: Text("Delete ${i.key}:${i.name}"),
                                trailing: Icon(Icons.arrow_forward),
                                onTap: () async {
                                  bool ok = await confirmDelete(context);
                                  if (ok) {
                                    store.dispatch(DeleteFriend(i.key));
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      context: context),
                  title: Text(
                    i.name,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  leading: CircleAvatar(
                    child: Text(buildInitials(i.name)),
                  ),
                  subtitle: Text(i.uid),
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute<void>(
                        builder: (BuildContext context) => FriendData(i)));
                  },
                );
              },
            );
        },
      ),
    );
  }

  String buildInitials(String fullName) {
    List<String> names = fullName.split(" ");
    if (names.length == 1) return names[0][0];
    return names[0][0] + names[1][0];
  }

  Future<bool> confirmDelete(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Confirm Delete'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('Confirm that you wish to delete this Item'),
                new Text('You\’re like me. I’m never satisfied.'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            new FlatButton(
              child: new Text('DELETE'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
