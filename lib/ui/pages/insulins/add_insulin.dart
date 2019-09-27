import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tabnav/actions/insulin_actions.dart';
import 'package:tabnav/models/app_state.dart';
import 'package:tabnav/models/icn.dart';
import 'package:tabnav/models/insulin.dart';

class AddInsulinPage extends StatefulWidget {
  final Insulin editInsulin;
  AddInsulinPage({this.editInsulin});

  @override
  _AddInsulinPageState createState() => _AddInsulinPageState();
}

class _AddInsulinPageState extends State<AddInsulinPage> {
  TextEditingController glucose = TextEditingController(text: "100");
  TextEditingController carbs = TextEditingController(text: "60");
  bool enableGlucose = true;
  Color glucoseColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      builder: (context, Store<AppState> store) {
        const double fSize = 25.0;

        return Scaffold(
          backgroundColor: Colors.blueGrey,
          appBar: AppBar(title: const Text("New Insulin")),
          body: Column(
            children: <Widget>[
              // Divider(),
              Card(
                margin: EdgeInsets.all(5.0),
                child: const ListTile(
                  leading: Text("Use:"),
                  subtitle: Text(
                      "Here you can enter your glucose and carbohydrates and the insulin dosage will appear on the list"),
                ),
              ),
              // Divider(),
              Card(
                  elevation: 5.0,
                  margin: EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.show_chart),
                        title: TextField(
                          enabled: true,
                          style:
                              TextStyle(fontSize: fSize, color: glucoseColor),
                          decoration: InputDecoration(suffixText: "mg/dL"),
                          keyboardType: TextInputType.numberWithOptions(),
                          controller: glucose,
                        ),
                        // trailing: Text(
                        //   'mg/dL',
                        //   style: TextStyle(color: glucoseColor),
                        // ),
                      ),
                      ListTile(
                        leading: Icon(Icons.restaurant),
                        title: TextField(
                          style:
                              TextStyle(fontSize: fSize, color: Colors.black),
                          decoration: InputDecoration(suffixText: "g"),
                          keyboardType: TextInputType.numberWithOptions(),
                          controller: carbs,
                        ),
                        // trailing: Text("g"),
                      ),
                      ButtonTheme.bar(
                        // make buttons use the appropriate styles for cards
                        child: ButtonBar(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Switch(
                                  value: !enableGlucose,
                                  onChanged: (bool state) {
                                    if (state)
                                      setGlucoseColorAndEnable(
                                          Colors.grey, false);
                                    else
                                      setGlucoseColorAndEnable(
                                          Colors.black, true);
                                  },
                                ),
                                Text("Carbs only")
                              ],
                            ),
                            FlatButton(
                              child: const Text('Clear'),
                              onPressed: () {
                                setState(() {
                                  glucose.clear();
                                  carbs.clear();
                                });
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
              invisibleMessage(!enableGlucose),
            ],
          ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.save),
            onPressed: () {
              if (store.state.icns.isEmpty) {
                showDialog(builder: emptyIcnDialog, context: context);
              } else {
                final int g = int.tryParse(glucose.text);
                final int c = int.tryParse(carbs.text);

                Dose dose = _calculate(g, c, store.state.icns, enableGlucose);

                Insulin insulin = Insulin(
                    carbs: c, glucose: g, time: DateTime.now(), dose: dose);

                if (widget.editInsulin?.key?.isNotEmpty ?? false) {
                  widget.editInsulin.glucose += 1;
                  store.dispatch(UpdateInsulin(widget.editInsulin));
                } else {
                  Completer completer = Completer();
                  completer.future.then((_) {
                    print("Added Insulin Callback");
                  });
                  store.dispatch(AddInsulin(insulin, completer: completer));
                }
                Navigator.of(context).pop();
              }
            },
          ),
        );
      },
    );
  }

  setGlucoseColorAndEnable(Color c, bool enable) {
    setState(() {
      enableGlucose = enable;
      glucoseColor = c;
    });
  }

  Widget emptyIcnDialog(context) {
    return AlertDialog(
      content: Text(
          "You don't have any sensitivity to calculate with.\nAdd one on the \"PUMP\" page"),
      title: Text("Problem."),
      actions: <Widget>[
        ButtonTheme.bar(
          child: ButtonBar(
            children: <Widget>[
              FlatButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        )
      ],
    );
  }
}

Widget invisibleMessage(bool enable) {
  if (enable)
    return Column(children: <Widget>[
      ListTile(
          subtitle: Text(
              "The Glucose value will be disconsidered from the calculations\nBut its value will still go to the list")),
      Divider()
    ]);
  else
    return Column();
}

Dose _calculate(int glucose, int carbs, List<Icn> icns, bool enableG) {
  if (icns.isEmpty) print("no sensitivity to calculate with");
  Dose dose = Dose(carbs: 0.0, glucose: 0.0, total: 0.0);
  final DateTime now = DateTime.now();
  final int comparator =
      int.tryParse(now.hour.toString() + now.minute.toString());
  Icn fit = icns.first;
  icns.forEach((icn) {
    final int iTime = int.tryParse(icn.time);
    final int iTimeFit = int.tryParse(fit.time);
    if (iTime < comparator && iTime > iTimeFit) {
      fit = icn;
    }
  });
  dose.carbs = double.tryParse((carbs / fit.carbs).toStringAsFixed(1));
  if (enableG)
    dose.glucose =
        double.tryParse(((glucose - 130) / fit.glucose).toStringAsFixed(1));
  else
    dose.glucose = 0.0;
  dose.total = dose.carbs + dose.glucose;
  return dose;
}
