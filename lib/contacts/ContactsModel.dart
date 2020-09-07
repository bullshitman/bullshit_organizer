import 'package:bullshit_organizer/model/BaseModel.dart';

class Contact {
  int id;
  String name;
  String telephone;
  String email;
  String birthday;

  @override
  String toString() {
    return "{ id=$id, name=$name, telephone=$telephone}, email=$email}, birthday=$birthday}";
  }
}

class ContactsModel extends BaseModel {
  void triggerRebuild() {
    print("#==# redraw widgets");
    notifyListeners();
  }
}

//singleton
ContactsModel contactsModel = ContactsModel();