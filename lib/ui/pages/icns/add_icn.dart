import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tabnav/actions/icns_actions.dart';
import 'package:tabnav/models/app_state.dart';
import 'package:tabnav/models/icn.dart';

class AddIcnPage extends StatefulWidget {
  final Icn editIcn;
  AddIcnPage({this.editIcn});

  @override
  _AddInsulinPageState createState() => _AddInsulinPageState();
}

timeString(int t) {
  if (t < 10) {
    return "0$t";
  } else {
    return t.toString();
  }
}

fmtTime(String time) {
  return time[0] + time[1] + ":" + time[2] + time[3];
}

class _AddInsulinPageState extends State<AddIcnPage> {
  var _formKey = GlobalKey<FormState>();
  String time = "0000";
  var glucose = TextEditingController();
  var carbs = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double fSize = 20.0;
    return Scaffold(
      appBar: AppBar(title: Text("Add Sensitivity")),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Divider(),
            const ListTile(
              subtitle: const Text("Here you can add a change in sensitivity.\nStarting from the Time below, so when you calculate a new glucose it uses these sensitivity values."),
            ),
            Divider(),
            Card(
              elevation: 5.0,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.access_alarm),
                    title: Text(
                      fmtTime(time),
                      style: TextStyle(color: Colors.black, fontSize: fSize),
                    ),
                    onTap: () async {
                      TimeOfDay picked = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      setState(() {
                        time =
                            timeString(picked.hour) + timeString(picked.minute);
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.show_chart),
                    title: TextFormField(
                      keyboardType: TextInputType.numberWithOptions(),
                      controller: glucose,
                      style: TextStyle(color: Colors.black, fontSize: fSize),
                      decoration: InputDecoration(
                          suffixText: "u/(mg/dL)", hintText: "Glucose"),
                      validator: (value) {
                        if (value.isEmpty) return "Can't be empty";
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.restaurant),
                    title: TextFormField(
                      keyboardType: TextInputType.numberWithOptions(),
                      controller: carbs,
                      style: TextStyle(color: Colors.black, fontSize: fSize),
                      decoration:
                          InputDecoration(suffixText: "u/g", hintText: "Food"),
                      validator: (value) {
                        if (value.isEmpty) return "Can't be empty";
                      },
                    ),
                  ),
                  ButtonTheme.bar(
                    // make buttons use the appropriate styles for cards
                    child: ButtonBar(
                      alignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          child: const Text('Clear'),
                          onPressed: () {
                            setState(() {
                              glucose.clear();
                              carbs.clear();
                              time = "0000";
                            });
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton:
          StoreBuilder(builder: (context, Store<AppState> store) {
        return FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              int g = int.tryParse(glucose.text);
              int c = int.tryParse(carbs.text);

              Icn icn = Icn(carbs: c, glucose: g, time: this.time);
              store.dispatch(AddIcn(icn));
              Navigator.of(context).pop();
            }
          },
        );
      }),
    );
  }
}
