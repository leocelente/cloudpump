import 'dart:async';

import 'package:tabnav/models/insulin.dart';

class FetchInsulins {
  bool chain;
  FetchInsulins({this.chain = false});
}

class FetchInsulinsFailed {}

class FetchInsulinsSucceeded {
  bool chain;
  List<Insulin> insulins;
  FetchInsulinsSucceeded(this.insulins, {this.chain = false});
}

class AddInsulin {
  Completer completer;
  Insulin insulin;
  AddInsulin(this.insulin, {this.completer});
}

class AddInsulinFailed {}

class AddInsulinSucceeded {}

class UpdateInsulin {
  Insulin newInsulin;
  UpdateInsulin(this.newInsulin);
}

class UpdateInsulinFailed {}

class UpdateInsulinSucceeded {}

class DeleteInsulin {
  String key;
  DeleteInsulin(this.key);
}

class DeleteInsulinFailed {}

class DeleteInsulinSucceeded {}
