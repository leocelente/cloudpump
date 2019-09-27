import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:redux/redux.dart';
import 'package:tabnav/actions/auth_actions.dart';
import 'package:tabnav/models/app_state.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      builder: (context, Store<AppState> store) {
        if (store.state.user?.uid?.isNotEmpty ?? false)
          return Scaffold(
              backgroundColor: Colors.blueGrey,
              appBar: AppBar(
                title: const Text("Account"),
              ),
              body: Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                buildImage(store.state.user.photoUrl),
                            child: Text(
                                buildInitials(store.state.user.displayName)),
                          ),
                          title: Text(store.state.user?.displayName ?? "__",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold)),
                          subtitle: Text(store.state.user?.email ?? "__"),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.person),
                              title: const Text("Log Out"),
                              trailing: IconButton(
                                icon: Icon(Icons.lock_outline),
                                onPressed: () {
                                  store.dispatch(new Logout());
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            ListTile(
                              // enabled: false,
                              onTap: () {
                                showAboutDialog(
                                    context: context,
                                    applicationIcon: FlutterLogo(),
                                    applicationName: "Cloud Pump",
                                    applicationVersion: "0.1.0",
                                    children: [Text("By Leonardo Celente"), Text("leocelente@gmail.com")]
                                    );
                              },
                              title: Text("About"),
                              leading: Icon(Icons.info),
                            )
                          ],
                        ),
                        elevation: 5.0,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Card(
                        elevation: 5.0,
                        child: QrImage(
                          data: store.state.user?.uid ?? "",
                          size: 300.0,
                          padding: EdgeInsets.all(15.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        else
          return Scaffold(
              appBar: AppBar(
                title: Text("Account"),
              ),
              body: Center(child: Text("No user")));
      },
    );
  }

  String buildInitials(String fullName) {
    List<String> names = fullName.split(" ");
    return names[0][0] + names[1][0];
  }

  ImageProvider buildImage(String url) {
    ImageProvider image;
    try {
      image = NetworkImage(url);
    } catch (Exception) {
      image = null;
    }
    return image;
  }
}

/*
ListView(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: buildImage(store.state.user.photoUrl),
                    child: Text(buildInitials(store.state.user.displayName)),
                  ),
                  title: Text(store.state.user?.displayName ?? "__"),
                  subtitle: Text(store.state.user?.email ?? "__"),
                ),
                ListTile(
                  leading: const Text("UID"),
                  title: Text(store.state.user?.uid ?? "__"),
                ),
                Divider(),
                Center(
                  child: QrImage(
                    data: store.state.user?.uid ?? "",
                    size: 200.0,
                    padding: EdgeInsets.all(15.0),
                  ),
                ),
                ListTile(
                  title: const Text("Log Out"),
                  trailing: IconButton(
                    icon: Icon(Icons.person),
                    onPressed: () {
                      store.dispatch(new Logout());
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
*/
