import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tabnav/models/app_state.dart';
import 'package:tabnav/models/insulin.dart';
import 'package:tabnav/ui/pages/insulins/add_insulin.dart';
import 'package:tabnav/ui/widgets/SimpleChart.dart';
import 'package:tabnav/ui/widgets/insulin_list.dart';
import 'package:tabnav/ui/widgets/insulin_stats.dart';

class InsulinsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          backgroundColor: Colors.blueGrey,
            floatingActionButton: FloatingActionButton(
              tooltip: "New Insulin",
              onPressed: () => buildAddInsulinPage(context),
              child: const Icon(Icons.add),
              elevation: 5.0,
            ),
            body: StoreBuilder(
              builder: (context, Store<AppState> store) {
                final List<Insulin> insulins = store.state.insulins;
                if (insulins.isEmpty)
                  return Center(
                    child: CircularProgressIndicator(
                      value: null,
                    ),
                  );
                return Flex(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  direction: Axis.vertical,
                  children: <Widget>[
                    Flexible(child: Card(child: SimpleChart(insulins), elevation: 5.0),flex:2 ,),
                    // Divider(
                    //   color: Colors.black,
                    // ),
                    Flexible(child: Card(child: InsulinStats(insulins), elevation: 5.0,),flex: 1,),
                    // Divider(
                    //   color: Colors.black,
                    // ),
                    Flexible(child: Card(child: InsulinList(insulins), elevation: 5.0,),flex: 1,),
                  ],
                );
              },
            )));
  }

  Future<void> buildAddInsulinPage(BuildContext context) {
    return Navigator.of(context).push(new MaterialPageRoute<void>(
        builder: (BuildContext context) => AddInsulinPage()));
  }
}

