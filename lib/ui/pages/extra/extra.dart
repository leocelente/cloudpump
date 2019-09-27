import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tabnav/models/app_state.dart';
import 'package:tabnav/ui/pages/extra/stats.dart';

class ExtraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Container(
          child: Card(
            child: Flex(
              mainAxisSize: MainAxisSize.min,
              direction: Axis.vertical,
              children: <Widget>[
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      ListTile(
                        title: Text("View Stats"),
                        subtitle: Text("View graphs and general stats"),
                        trailing: IconButton(
                          icon: Icon(Icons.show_chart),
                          onPressed: () {},
                        ),
                        onTap: () {
                          print("TAP");

                          Navigator.of(context).push(
                              new MaterialPageRoute<void>(
                                  builder: (BuildContext context) {
                            return StoreBuilder(
                              builder: (context, Store<AppState> store) {
                                return StatsPage(store.state.user.uid);
                              },
                            );
                          }));
                        },
                      ),
                      ListTile(
                        title: Text("Read NFC Sensor"),
                        subtitle:
                            Text("Read glucose data from a FreeStyle Libre"),
                        trailing: IconButton(
                          icon: Icon(Icons.nfc),
                          onPressed: () {},
                        ),
                        enabled: false,
                      ),
                      ListTile(
                        title: Text("Sync with a Bluetooth Monitor"),
                        subtitle: Text("Get data from a ESP32_CGM device"),
                        trailing: IconButton(
                          icon: Icon(Icons.bluetooth),
                          onPressed: () {},
                        ),
                        enabled: false,
                      ),
                      ListTile(
                        title: Text("Import Data"),
                        subtitle: Text(
                            "Import data from a csv file (from the Libre Desktop App)"),
                        trailing: IconButton(
                          icon: Icon(Icons.import_export),
                          onPressed: () {},
                        ),
                        enabled: false,
                      ),
                      ListTile(
                        title: Text("Export Data"),
                        subtitle: Text("Share your data as a csv file"),
                        trailing: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {},
                        ),
                        enabled: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
