import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum ApiDataBucket {
  insulins,
  friends,
  sensitivity,
}

class DatabaseApi {
  final String currentUid;

  DatabaseApi(this.currentUid);

  Future<dynamic> fetchAllData({String uid}) async {
    if (uid == null) uid = this.currentUid;
    Future<dynamic> future = new Future(() {
      DatabaseReference ref =
          FirebaseDatabase.instance.reference().child("users/$uid");
      ref.keepSynced(true);
      return ref.once().then((DataSnapshot snap) {
        return snap.value;
      }).catchError((err) {
        return err;
      });
    });
    return future;
  }

  Future<void> add(ApiDataBucket bucket, dynamic data, {String uid}) {
    String b = _selectBucket(bucket);
    if (uid == null) uid = this.currentUid;

    Future<void> future = Future(() {
      return FirebaseDatabase.instance
          .reference()
          .child("users/$uid/$b")
          .push()
          .set(data.toMap());
    });
    return future;
  }

  Future<void> delete(ApiDataBucket bucket, String key, {String uid}) {
    String b = _selectBucket(bucket);
    if (uid == null) uid = this.currentUid;

    Future<void> future = Future(() {
      return FirebaseDatabase.instance
          .reference()
          .child("users/$uid/$b/$key")
          .remove();
    });
    return future;
  }

  Future<void> update(ApiDataBucket bucket, dynamic data, {String uid}) {
    if (uid == null) uid = this.currentUid;
    String b = _selectBucket(bucket);

    Future<void> future = Future(() {
      return FirebaseDatabase.instance
          .reference()
          .child("users/$uid/$b/${data.key}")
          .push()
          .set(data.toMap());
    });
    return future;
  }

  String _selectBucket(ApiDataBucket bucket) {
    String b = "tests";
    if (bucket == ApiDataBucket.insulins)
      b = "insulins";
    else if (bucket == ApiDataBucket.friends)
      b = "friends";
    else if (bucket == ApiDataBucket.sensitivity) b = "icns";
    return b;
  }
}

class AuthApi {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    return _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    return _auth.signOut();
  }
}
