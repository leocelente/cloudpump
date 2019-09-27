import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tabnav/actions/auth_actions.dart';
import 'package:tabnav/actions/general_actions.dart';
// import 'package:tabnav/general/constants.dart';
import 'package:tabnav/models/app_state.dart';
import 'package:tabnav/ui/pages/extra/extra.dart';
import 'package:tabnav/ui/pages/friends/friends.dart';
import 'package:tabnav/ui/pages/insulins/insulins.dart';

class RootApp extends StatelessWidget {
  final List<Page> _pages = [
    Page("Home", InsulinsPage(), Icons.home),
    Page("Friends", FriendsPage(), Icons.people),
    Page("Extra", ExtraPage(), Icons.warning),
  ];
  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      onInit: (Store<AppState> store) {
        FirebaseAuth.instance.onAuthStateChanged.listen((FirebaseUser user) {
          if (user == null) {
            store.dispatch(new Login());
          } else {
            store.dispatch(new LoginSucceded(user));
          }
        });
      },
      builder: (context, Store<AppState> store) {
        Color c = Colors.black;
        if (store.state.user != null ?? false) c = Colors.white;
        void handleTabChange(int index) {
          store.dispatch(new SetTabIndex(index));
        }

        int index = 0;
        if (store.state.general != null) index = store.state.general.getIndex();

        return Scaffold(
          appBar: AppBar(
            title: Text(_pages[index].title),
            leading: Icon(_pages[index].icon),
            actions: <Widget>[
               FlatButton(
                child: Row(children: <Widget>[Icon(Icons.tune), Text(" PUMP")]),
                textColor: Colors.white,
                onPressed: () => Navigator.pushNamed(
                      context,
                      '/pump',
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.person),
                color: c,
                tooltip: 'Account',
                onPressed: () => Navigator.pushNamed(
                      context,
                      '/account',
                    ),
              ),
            ],
          ),
          
          body: _pages[index].widget,
          backgroundColor: Colors.white24,
          bottomNavigationBar: BottomNavigationBar(
            // fixedColor: Colors.blueGrey[800],
            items: _pages.map((page) {
              return BottomNavigationBarItem(
                  
                  icon: Icon(page.icon), title: Text(page.title));
            }).toList(),
            currentIndex: index,
            onTap: handleTabChange,
            type: BottomNavigationBarType.fixed,
          ),
        );
      },
    );
  }
}

class Page {
  final String title;
  final Widget widget;
  final IconData icon;

  Page(this.title, this.widget, this.icon);
}

