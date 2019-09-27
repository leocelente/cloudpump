import 'package:flutter/material.dart';
import 'package:tabnav/api/api.dart';
import 'package:tabnav/models/insulin.dart';
import 'package:tabnav/ui/widgets/SimpleChart.dart';
import 'package:tabnav/ui/widgets/insulin_list.dart';

class StatsPage extends StatefulWidget {
  final String userid;
  StatsPage(this.userid);
  @override
  _StatsPageState createState() => _StatsPageState(this.userid);
}

class _StatsPageState extends State<StatsPage> {
  DatabaseApi api;
  bool showAll = false;
  int range = 7;
  List<Insulin> insulins = [];
  _StatsPageState(String userid) {
    fetchData(userid);
  }

  void fetchData(String userid) {
    api = new DatabaseApi(userid);
    api.fetchAllData().then((map) {
      setState(() {
        if (showAll)
          insulins = Insulin.parseList((map as Map)['insulins']);
        else
          insulins = Insulin.parseList((map as Map)['insulins'])
              .where(testTime)
              .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(insulins.length);
    if (insulins.isEmpty)
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: CircularProgressIndicator(
            value: null,
          ),
        ),
      );
    return Container(
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        // resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: const Text("General Stats"),
          actions: <Widget>[
            Row(
              children: <Widget>[
                PopupMenuButton<int>(
                  icon: const Icon(Icons.calendar_today),
                  initialValue: range,
                  itemBuilder: buildMenuItem,
                  onSelected: (int value) {
                    range = value;
                    fetchData(widget.userid);
                  },
                ),
                // Text(rangeText(), style: TextStyle(fontSize: 16.0)),
              ],
            )
          ],
        ),
        body: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Flexible(
                child: Card(
              child: SimpleChart(insulins),
              elevation: 5.0,
            )),
            // const Divider(
            //   color: Colors.black,
            // ),
            Flexible(
                child: Card(
              child: SimpleChart(insulins, subvalue: Subvalues.dose),
              elevation: 5.0,
            )),
            // const Divider(
            //   color: Colors.black,
            // ),
            Flexible(
                child: Card(
              child: SimpleChart(insulins, subvalue: Subvalues.food),
              elevation: 5.0,
            )),
            // const Divider(
            //   color: Colors.black,
            // ),
            Flexible(
              child: Card(
                elevation: 5.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "More Stats",
                      ),
                      leading: Icon(Icons.assessment),
                      trailing: Icon(Icons.forward),
                      enabled: false,
                    ),
                    ListTile(
                      title: Text("View Data in List"),
                      leading: Icon(Icons.list),
                      trailing: Icon(Icons.forward),
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: Text("Full List"),
                                ),
                                body: Flex(
                                  direction: Axis.vertical,
                                  children: <Widget>[
                                    Flexible(
                                      flex: 1,
                                      child: InsulinList(insulins),
                                    )
                                  ],
                                ))));
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<PopupMenuEntry<int>> buildMenuItem(context) {
    return [
      const PopupMenuItem(
        child: Text("7 Days"),
        value: 7,
      ),
      const PopupMenuItem(
        child: Text("30 Days"),
        value: 30,
      ),
      const PopupMenuItem(
        child: Text("All"),
        value: 0,
      ),
    ];
  }

  String rangeText() {
    if (range == 0)
      return "All  ";
    else if (range == 30)
      return "Month  ";
    else
      return "Week  ";
  }

  void onShowAllChange(bool state) {
    showAll = state;
    fetchData(this.widget.userid);
  }

  bool testTime(Insulin insulin) {
    if (range == 0) return true;
    return insulin.time.millisecondsSinceEpoch >
        DateTime.now().millisecondsSinceEpoch - 1000 * 60 * 60 * 24 * range;
  }
}
