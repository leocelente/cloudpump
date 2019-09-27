import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tabnav/actions/icns_actions.dart';
import 'package:tabnav/models/app_state.dart';
import 'package:tabnav/models/icn.dart';

class IcnList extends StatelessWidget {
  IcnList(this.icns, {this.isReadOnly = false});
  final List<Icn> icns;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      shrinkWrap: true,
        itemCount: icns.length,
        itemBuilder: (context, index) {
          final Icn i = icns[index];
          return ListTile(
            isThreeLine: true,
            onLongPress: () {
              if (!isReadOnly) {
                showModalBottomSheet(
                    builder: (builder) {
                      return Container(
                        child: _buildModal(i),
                      );
                    },
                    context: context);
              }
            },
            leading: const Icon(
              Icons.access_alarm,
              size: 35.0,
            ),
            title: Text(
              fmtTime(i.time),
              style: TextStyle(fontSize: 20.0),
            ),
            subtitle: Text(
                "Units per mg/dL of Glucose: ${i.glucose} \nUnits per g of food: ${i.carbs}"),
            trailing: Text(i.glucose.toString() + " | " + i.carbs.toString(),
                style: TextStyle(fontSize: 20.0)),
          );
        },
      );
  }

  fmtTime(String time) {
    return time[0] + time[1] + ":" + time[2] + time[3];
  }

  _buildModal(Icn i) {
    return StoreBuilder(builder: (context, Store<AppState> store) {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Edit"),
              onTap: () {
                // Navigator.of(context).push(
                //     new MaterialPageRoute<void>(
                //         builder: (BuildContext context) =>
                //             AddInsulinPage(editInsulin: i,)));
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_forever),
              title: Text("Delete ${i.key}:${i.time}"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () async {
                bool ok = await confirmDelete(context);
                if (ok) {
                  store.dispatch(DeleteIcn(i.key));
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    });
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
                new Text('This operation cannot be undone.'),
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
