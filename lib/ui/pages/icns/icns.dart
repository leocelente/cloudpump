// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
// import 'package:tabnav/actions/icns_actions.dart';
import 'package:tabnav/models/app_state.dart';
// import 'package:tabnav/models/icn.dart';
import 'package:tabnav/ui/pages/icns/add_icn.dart';
import 'package:tabnav/ui/widgets/icns_list.dart';

class IcnPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
          appBar: AppBar(title: const Text("Sensibility")),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (BuildContext context) => AddIcnPage()));
            },
          ),
          body: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              // const Divider(),
              // ListTile(
              //   subtitle: Text(
              //       "This is where you program the sensibility that is used to calculate the Insulin dosage"),
              // ),
              // const Divider(),
              Flexible(
                flex: 1,
                child: StoreBuilder(builder: (_, Store<AppState> store) {
                  return Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Flexible(flex: 1, child: Card(child: IcnList(store.state.icns), elevation: 5.0,)),
                    ],
                  );
                }),
              )
            ],
          )),
    );
  }
}
