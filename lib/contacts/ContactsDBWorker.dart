import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bullshit_organizer/utils.dart' as utils;
import 'ContactsModel.dart';

class ContactsDBWorker {
  ContactsDBWorker._();
  static final ContactsDBWorker db = ContactsDBWorker._();

  Database _db;

  // database instance
  Future get database async {
    if (_db == null) {
      _db = await init();
    }
    return _db;
  }

  //database initialization
  Future<Database> init() async {
    String path = join(utils.docsDir.path, "contacts.db");
    Database db = await openDatabase(
        path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
          await inDB.execute(
              "CREATE TABLE IF NOT EXISTS contacts ("
                  "id INTEGER PRIMARY KEY,"
                  "name TEXT,"
                  "telephone TEXT,"
                  "email TEXT,"
                  "birthday TEXT"
                  ")"
          );
        }
    );
    return db;
  }
  //converting contact from a map
  Contact contactFromMap(Map inMap) {
    Contact contact = Contact();
    contact.id = inMap["id"];
    contact.name = inMap["name"];
    contact.telephone = inMap["telephone"];
    contact.email = inMap["email"];
    contact.birthday = inMap["birthday"];
    return contact;
  }

  /*
  CONVERTING VEGETARIANS !..!_
  */

  //converting map from a contact
  Map<String, dynamic> contactToMap(Contact inContact) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inContact.id;
    map["name"] = inContact.name;
    map["telephone"] = inContact.telephone;
    map["email"] = inContact.email;
    map["birthday"] = inContact.birthday;
    return map;
  }

  //create a contact
  Future create(Contact inContact) async {
    Database db = await database;
    var val = await db.rawQuery(
        "SELECT MAX(id) + 1 AS id FROM contacts");
    int id = val.first["id"];
    if (id == null) {id = 1;}
    return await db.rawInsert(
        "INSERT INTO contacts (id, name, telephone, email, birthday) "
            "VALUES (?, ?, ?, ?, ?)",
        [inContact.id, inContact.name, inContact.telephone, inContact.email, inContact.birthday]
    );
  }

  //get a contact
  Future<Contact> get(int inID) async {
    Database db = await database;
    var rec = await db.query("contacts", where: "id = ?", whereArgs: [inID]);
    return contactFromMap(rec.first);

  }

  //get all contacts
  Future<List> getAll() async {
    Database db = await database;
    var recs = await db.query("contacts");
    return recs.isNotEmpty ? recs.map((m) => contactFromMap(m)).toList() : [ ];
  }

  //update a contact
  Future update(Contact inContact) async {
    Database db = await database;
    return await db.update("contacts", contactToMap(inContact), where: "id = ?", whereArgs: [inContact.id]);
  }

  //delete a contact
  Future delete(int inID) async {
    Database db = await database;
    return await db.delete("contacts", where:  "id = ?", whereArgs: [inID]);
  }
}