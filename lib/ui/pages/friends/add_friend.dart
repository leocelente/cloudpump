import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tabnav/actions/friends_actions.dart';
import 'package:tabnav/models/app_state.dart';
import 'package:tabnav/models/friend.dart';

class AddFriendPage extends StatefulWidget {
  @override
  _AddFriendFormState createState() => _AddFriendFormState();
}

class _AddFriendFormState extends State<AddFriendPage> {
  var _formKey = GlobalKey<FormState>();
  var nameCtrl = TextEditingController();
  var uidCtrl = TextEditingController();
  var barcodes = <Barcode>[];
  @override
  void initState() {
    super.initState();
    FlutterMobileVision.start().then((x) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    double fSize = 21.0;
    return Scaffold(backgroundColor: Colors.blueGrey,
        appBar: AppBar(title: Text("Add Friend")),
        body: Form(
          
          key: _formKey,
          child: Column(children: <Widget>[
            // Divider(),
            Card(
              child: ListTile(
                leading: Text("Use:"),
                subtitle: Text(
                    "Put your new friend's name and scan their UID with the Camera Button"),
              ),
            ),
            // Divider(),
            Card(
              elevation: 5.0,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.person_outline),
                    title: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Name",
                      ),
                      style: TextStyle(fontSize: fSize, color: Colors.black),
                      controller: nameCtrl,
                      validator: (value) {
                        if (value.isEmpty) return "Your friend needs a name";
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.code),
                    title: TextFormField(
                      decoration: InputDecoration(
                        hintText: "UID",
                      ),
                      style: TextStyle(fontSize: fSize, color: Colors.black),
                      controller: uidCtrl,
                      validator: (value) {
                        if (value.isEmpty) return "Your friend needs an UID";
                      },
                    ),
                    trailing: IconButton(
                      iconSize: 30.0,
                      icon: Icon(Icons.camera_alt),
                      onPressed: () async {
                        // barcodes = await FlutterMobileVision.scan(
                        //   formats: Barcode.QR_CODE,
                        //   multiple: false,
                        // );
                        try {
                          barcodes = await FlutterMobileVision.scan(
                            flash: false,
                            autoFocus: true,
                            formats: Barcode.QR_CODE,
                            multiple: false,
                            waitTap: false,
                            showText: false,
                            preview: FlutterMobileVision.PREVIEW,
                            camera: FlutterMobileVision.CAMERA_BACK,
                            fps: 15.0,
                          );
                        } on Exception {
                          barcodes.add(new Barcode('Failed to get barcode.'));
                          showDialog(
                              builder: failedScanDialog, context: context);
                        }
                        uidCtrl.text = barcodes.first.displayValue;
                        barcodes.clear();
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
                              nameCtrl.clear();
                              uidCtrl.clear();
                            });
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ]),
        ),
        floatingActionButton: StoreBuilder(
          builder: (context, Store<AppState> store) {
            return FloatingActionButton(
                child: Icon(Icons.save),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    print(
                        "The current state is: name: ${nameCtrl.text} and uid: ${uidCtrl.text}");
                    Friend friend = Friend(
                      name: nameCtrl.text,
                      uid: uidCtrl.text,
                    );
                    store.dispatch(AddFriend(friend));

                    Navigator.of(context).pop();
                  }
                });
          },
        ));
  }

  Widget failedScanDialog(context) {
    return AlertDialog(
      content: Text("Barcode Scan Failed"),
      title: Text("Problem."),
      actions: <Widget>[
        ButtonTheme.bar(
          child: ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        )
      ],
    );
  }
}
