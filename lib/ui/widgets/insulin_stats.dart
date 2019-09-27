import 'package:flutter/material.dart';
import 'package:tabnav/models/insulin.dart';
import 'dart:math' as math;

class InsulinStats extends StatelessWidget {
  final List<Insulin> insulins;

  InsulinStats(this.insulins);
  @override
  Widget build(BuildContext context) {
    if (insulins.isNotEmpty) {
      final Stats avg = new Stats(insulins);
      return ListView(
          // physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            ListTile(
              title: const Text("Average Glucose", style: TextStyle(fontSize: 14.0),),
              dense: true,
              trailing: Text(avg.glucose.toStringAsFixed(1).toString(), style: TextStyle(fontSize: 16.0),),
            ),
            Divider(color: Colors.black45, height: 0.0,),
            ListTile(
              title: const Text("Average Dose", style: TextStyle(fontSize: 14.0),),
              dense: true,
              trailing: Text(avg.dose.toStringAsFixed(1).toString(), style: TextStyle(fontSize: 16.0),),
            ),
            Divider(color: Colors.black45, height: 0.0,),
            ListTile(
              title: const Text("Standard Deviation", style: TextStyle(fontSize: 14.0),),
              dense: true,
              trailing: Text(avg.sd.toStringAsFixed(1).toString(), style: TextStyle(fontSize: 16.0),),
            ),
          ],
        );
    } else
      return Center(child: CircularProgressIndicator(value: null,),);
  }
}

class Stats {
  final List<Insulin> list;
  double dose, glucose, sd;
  Stats(this.list) {
    double tDose = 0.0, tGlucose = 0.0, tSd = 0.0;
    final int c = list.length;
    list.forEach((Insulin insulin) {
      tDose += insulin.dose.total;
      tGlucose += insulin.glucose;
    });

    this.dose = tDose / c;
    this.glucose = tGlucose / c;

    list.forEach((Insulin insulin) {
      tSd += math.pow(insulin.glucose - this.glucose, 2);
    });
    this.sd = math.sqrt(tSd/ c);
  }
}
