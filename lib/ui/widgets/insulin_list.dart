import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:tabnav/actions/insulin_actions.dart';
import 'package:tabnav/models/app_state.dart';
import 'package:tabnav/models/insulin.dart';

import 'package:tabnav/ui/pages/insulins/add_insulin.dart';

const List<String> weekdays = ["Seg", "Ter", "Qua", "Qui", "Sex", "Sab", "Dom"];

class InsulinList extends StatelessWidget {
  InsulinList(this.insulins, {this.isReadOnly = false});
  final bool isReadOnly;
  final List<Insulin> insulins;
  @override
  Widget build(BuildContext context) {
    if (insulins.isEmpty) {
      return Center(
        child: Column(
          children: <Widget>[
            // Icon(Icons.cloud_download),
            CircularProgressIndicator(value: null,),
            const Text("No data, maybe loading...")
          ],
        ),
      );
    } else {
      return ListView.builder(
          itemCount: insulins.length,
          itemBuilder: (context, index) {
            final Insulin i = insulins[index];
            final DateFormat dfHm = DateFormat.Hm();
            final DateFormat dfDm = DateFormat("dd/MM");

            return ListTile(
              
              onLongPress: () {
                if (!isReadOnly) {
                  showModalBottomSheet(
                      builder: (builder) {
                        return Container(child: _buildModal(i));
                      },
                      context: context);
                }
              },
              leading: Text(
                i.dose.total.toString() + "u",
                style: TextStyle(fontSize: 20.0,fontWeight: index==0 ? FontWeight.w600 : FontWeight.normal),

              ),
              title: Text(i.glucose.toString() + "mg/dL"),
              subtitle: Text("G:${i.dose.glucose}u | C:${i.dose.carbs}u"),
              trailing: Text(
                  "${weekdays[i.time.weekday - 1]}, ${dfDm.format(i.time)} @ ${dfHm.format(i.time)}"),
            );
          },
        );
    }
  }

  _buildModal(Insulin i) {
    return StoreBuilder(builder: (context, Store<AppState> store) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Edit"),
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute<void>(
                  builder: (BuildContext context) => AddInsulinPage(
                        editInsulin: i,
                      )));
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: Text("Delete ${i.glucose}"),
            onTap: () async {
              bool ok = await confirmDelete(context);
              if (ok) {
                store.dispatch(DeleteInsulin(i.key));
              }
              Navigator.of(context).pop();
            },
          ),
        ],
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
                new Text('This action cannot be undone'),
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
