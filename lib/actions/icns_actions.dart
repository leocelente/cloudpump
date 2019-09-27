import 'package:tabnav/models/icn.dart';

class FetchIcns {}

class FetchIcnsFailed {}

class FetchIcnsSucceeded {
  List<Icn> icns;
  FetchIcnsSucceeded(this.icns);
}

class AddIcn {
  Icn icn;
  AddIcn(this.icn);
}

class AddIcnFailed {}

class AddIcnSucceeded {}

class UpdateIcn {
  Icn newIcn;
  UpdateIcn(this.newIcn);
}

class UpdateIcnFailed {}

class UpdateIcnSucceeded {}

class DeleteIcn {
  String key;
  DeleteIcn(this.key);
}

class DeleteIcnFailed {}

class DeleteIcnSucceeded {}
