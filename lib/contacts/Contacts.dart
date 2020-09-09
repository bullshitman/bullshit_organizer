import 'package:bullshit_organizer/contacts/ContactsEntry.dart';
import 'package:bullshit_organizer/contacts/ContactsList.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'ContactsModel.dart';
import 'ContactsDBWorker.dart';
import 'ContactsList.dart';
import 'ContactsEntry.dart';

//Contacts screen
class Contacts extends StatelessWidget {
  Contacts() {
    print("#==# Contacts.constructor");
    contactsModel.loadData("contacts", ContactsDBWorker.db);
  }

  @override
  Widget build(BuildContext inContext) {
    print("#==# Contacts.build()");
    return ScopedModel<ContactsModel>(
      model: contactsModel,
      child: ScopedModelDescendant<ContactsModel>(
        builder: (BuildContext inContext, Widget inChild, ContactsModel inModel) {
          return IndexedStack(
            index: inModel.stackIndex,
            children: [
              ContactsList(),
              ContactsEntry(),
            ],
          );
        }
      )
    );
  }
}