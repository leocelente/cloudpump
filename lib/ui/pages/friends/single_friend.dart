import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tabnav/actions/friends_actions.dart';
import 'package:tabnav/models/app_state.dart';
import 'package:tabnav/models/friend.dart';
import 'package:tabnav/models/icn.dart';
import 'package:tabnav/models/insulin.dart';
import 'package:tabnav/ui/widgets/SimpleChart.dart';
import 'package:tabnav/ui/widgets/icns_list.dart';
import 'package:tabnav/ui/widgets/insulin_list.dart';
import 'package:tabnav/ui/widgets/insulin_stats.dart';

class FriendData extends StatefulWidget {
  final Friend friend;
  FriendData(this.friend);
  @override
  _FriendDataState createState() => _FriendDataState();
}

class _FriendDataState extends State<FriendData> {
  List<Insulin> insulins;
  List<Icn> icns;
  @override
  void initState() {
    super.initState();
    this.insulins = [];
    this.icns = [];
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      onInit: (Store<AppState> store) {
        Completer c = new Completer();
        c.future.then((data) {
          this.insulins = Insulin.parseList(data['insulins']);
          this.icns = Icn.parseList(data['icns']);
          // print(this.insulins);
          print(data['insulins']);
          print("Length: " + this.insulins.length.toString());
        });
        store.dispatch(new FetchFriendData(widget.friend, completer: c));
      },
      builder: (c, Store<AppState> store) {
        return Container(
          child: Scaffold(
            backgroundColor: Colors.blueGrey,
              appBar: AppBar(
                title: Text(widget.friend.name),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      Completer c = new Completer();
                      c.future.then((data) {
                        this.insulins = Insulin.parseList(data['insulins']);
                        this.icns = Icn.parseList(data['icns']);
                        // print(this.insulins);
                        print(data['insulins']);
                        print("New Length: " + this.insulins.length.toString());
                      });
                      store.dispatch(
                          new FetchFriendData(widget.friend, completer: c));
                    },
                  )
                ],
              ),
              body: Flex(
                direction: Axis.vertical,
                // mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Card(elevation: 5.0,child: SimpleChart(insulins)),
                  ),
                  // Divider(
                  //   color: Colors.black,
                  // ),
                  Flexible(
                    flex: 1,
                    child: Card(elevation: 5.0,child: IcnList(this.icns, isReadOnly: true,)),
                  ),
                  // Divider(
                  //   color: Colors.black,
                  // ),
                  Flexible(
                    flex: 1,
                    child: Card(elevation: 5.0,child: InsulinStats(insulins)),
                  ),
                  // Divider(
                  //   color: Colors.black,
                  // ),
                  Flexible(
                    flex: 1,
                    child: Card(elevation: 5.0,child: InsulinList(insulins, isReadOnly: true,)),
                  ),
                  // Divider(
                  //   color: Colors.black,
                  // ),
                ],
              )),
        );
      },
    );
  }

  getData(Store<AppState> store) {
    Completer c = new Completer();
    c.future.then((data) {
      this.insulins = Insulin.parseList(data['insulins']);
      this.icns = Icn.parseList(data['icns']);
      // print(this.insulins);
      print(data['insulins']);
      print(this.icns.length);
    });
    store.dispatch(new FetchFriendData(widget.friend, completer: c));
  }
}
/*
ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,

              children: <Widget>[
                ListTile( 
                  subtitle: Text("viewing info on friend: ${widget.friend.uid}"),
                ),
                // Divider(color: Colors.black),
                SimpleChart(this.insulins),
                // Divider(color: Colors.black),
                InsulinStats(this.insulins),
                // Divider(color: Colors.black),
                IcnList(this.icns, isReadOnly: true,),
                // Divider(color: Colors.black),
                InsulinList(this.insulins, isReadOnly: true,),
              ],
            ),
*/
