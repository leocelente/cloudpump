import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tabnav/models/app_state.dart';
import 'package:tabnav/models/insulin.dart';

enum Subvalues {
  glucose,
  dose,
  food,
}

class SimpleChart extends StatelessWidget {
  final List<charts.Series<Insulin, DateTime>> series = [];
  final List<Insulin> insulins;
  final Subvalues subvalue;
  SimpleChart(this.insulins, {this.subvalue=Subvalues.glucose});

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      builder: (_, Store<AppState> store) {
        if (this.insulins.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              value: null,
            ),
          );
        } else
          return charts.TimeSeriesChart(
            [
              charts.Series<Insulin, DateTime>(
                measureLowerBoundFn: (_, __)=>40,
                measureUpperBoundFn: (_, __)=>400,
                id: 'glucose',
                colorFn: selectSubtypeColor,
                domainFn: (Insulin i, _) => i.time.toLocal(),
                measureFn: selectSubvalueMeasure,
                displayName: selectSubvalueDisplay(),
                data: this.insulins,
                // fillPatternFn: (_,__)=>charts.FillPatternType.forwardHatch,
                // fillColorFn: (_,__)=> charts.MaterialPalette.red.shadeDefault
              ),
              
            ],
            animate: false,
            dateTimeFactory: const charts.LocalDateTimeFactory(),
          );
      },
    );
  }

  charts.Color selectSubtypeColor(Insulin i, index) {
    if (this.subvalue == Subvalues.glucose)
      return charts.MaterialPalette.deepOrange.shadeDefault;
    else if (this.subvalue == Subvalues.dose)
      return charts.MaterialPalette.blue.shadeDefault;
    else if (this.subvalue == Subvalues.food)
      return charts.MaterialPalette.indigo.shadeDefault;
    else
      return charts.MaterialPalette.deepOrange.shadeDefault;
  }

  String selectSubvalueDisplay() {
    if (this.subvalue == Subvalues.glucose)
      return "Glucose";
    else if (this.subvalue == Subvalues.dose)
      return "Dosage";
    else if (this.subvalue == Subvalues.food)
      return "Food";
    else
      return "Glucose";
  }

  num selectSubvalueMeasure(Insulin i, _) {
    if (this.subvalue == Subvalues.glucose)
      return i.glucose;
    else if (this.subvalue == Subvalues.dose)
      return i.dose.total;
    else if (this.subvalue == Subvalues.food)
      return i.carbs;
    else
      return i.glucose;
  }
}
