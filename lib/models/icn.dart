class Icn {
  String key;
  int carbs;
  int glucose;
  String time;
  Icn({this.time, this.carbs, this.glucose, this.key});

  Map<String, dynamic> toMap() {
    return {
      "carbs": this.carbs,
      "glucose": this.glucose,
      "time": this.time,
    };
  }

  Icn.fromMap(Map<dynamic, dynamic> data, String k) {
    this.glucose = int.tryParse(data['glucose'].toString());
    this.carbs = int.tryParse(data['carbs'].toString());
    this.time = data['time'].toString();
    this.key = k;
  }

  static List<Icn> parseList(Map data) {
    List<dynamic> keys = data.keys.toList();
    List<Icn> icns = [];
    keys.forEach((k) {
      icns.add(Icn.fromMap(data[k], k));
    });
    return icns;
  }
}