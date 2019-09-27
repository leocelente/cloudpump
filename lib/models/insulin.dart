class Dose {
  double glucose;
  double carbs;
  double total;
  Dose({this.glucose, this.carbs, this.total});

  Map<dynamic, dynamic> toMap() {
    return {
      "glucose": this.glucose.toStringAsFixed(1),
      "carbs": this.carbs.toStringAsFixed(1),
      "total": this.total.toStringAsFixed(1)
    };
  }

  Dose.fromMap(Map data) {
    this.glucose = double.tryParse(data['glucose'].toString());
    this.carbs = double.tryParse(data['carbs'].toString());
    this.total = double.tryParse(data['total'].toString());
  }
  Dose.empty() {
    this.glucose = 0.0;
    this.carbs = 0.0;
    this.total = 0.0;
  }
}

class Insulin {
  String key;
  int glucose;
  int carbs;
  DateTime time;
  Dose dose;
  Insulin({this.glucose, this.carbs, this.dose, this.time});

  static List<Insulin> parseList(Map data) {
    List<dynamic> keys = data.keys.toList();
    List<Insulin> insulins = [];
    keys.forEach((k) {
      insulins.add(Insulin.fromMap(data[k], k));
    });
    insulins.sort((a, b) {
      return b.time.compareTo(a.time);
    });
    return insulins;
  }

  Insulin.fromInt(int glucose, DateTime time) {
    this.glucose = glucose;
    this.carbs = 0;
    this.time = time;
    this.dose = Dose.empty();
  }

  Insulin.fromMap(Map<dynamic, dynamic> data, String k) {
    this.glucose = int.tryParse(data['glucose'].toString());
    this.carbs = int.tryParse(data['carbs'].toString());
    int t = int.tryParse(data['time'].toString());
    this.time = DateTime.fromMillisecondsSinceEpoch(t);
    this.dose = Dose.fromMap(data['dose']);
    this.key = k;
  }

  Map<String, dynamic> toMap() {
    return {
      "glucose": this.glucose.toString(),
      "carbs": this.carbs.toString(),
      "time": this.time.millisecondsSinceEpoch.toString(),
      "dose": dose.toMap(),
    };
  }
}