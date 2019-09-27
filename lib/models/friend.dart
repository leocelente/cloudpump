class Friend {
  String key;
  String uid;
  String name;

  Friend({this.uid, this.name, this.key});
  Map<String, dynamic> toMap() {
    return {
      "name": this.name,
      "uid": this.uid,
    };
  }

  Friend.fromMap(Map<dynamic, dynamic> data, String k) {
    this.name = data['name'].toString();
    this.uid = data['uid'].toString();
    this.key = k;
  }

  static List<Friend> parseList(Map data) {
    List<dynamic> keys = data.keys.toList();
    List<Friend> friends = [];
    keys.forEach((k) {
      friends.add(Friend.fromMap(data[k], k));
    });
    return friends;
  }
}
