import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bullshit_organizer/utils.dart' as utils;
import 'AppointmentsModel.dart';

class AppointmentsDBWorker {
  AppointmentsDBWorker._();
  static final AppointmentsDBWorker db = AppointmentsDBWorker._();

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
    String path = join(utils.docsDir.path, "appointments.db");
    Database db = await openDatabase(
        path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
          await inDB.execute(
              "CREATE TABLE IF NOT EXISTS appointments ("
                  "id INTEGER PRIMARY KEY,"
                  "title TEXT,"
                  "description TEXT,"
                  "apptDate TEXT,"
                  "apptTime TEXT"
                  ")"
          );
        }
    );
    return db;
  }
  //converting Appointment from a map
  Appointment apptFromMap(Map inMap) {
    Appointment appointment = Appointment();
    appointment.id = inMap["id"];
    appointment.title = inMap["title"];
    appointment.description = inMap["description"];
    appointment.apptDate = inMap["apptDate"];
    appointment.apptTime = inMap["apptTime"];
    return appointment;
  }

  /*
  CONVERTING VEGETARIANS !..!_
  */

  //converting map from an Appointment
  Map<String, dynamic> apptToMap(Appointment inAppointments) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inAppointments.id;
    map["title"] = inAppointments.title;
    map["description"] = inAppointments.description;
    map["apptDate"] = inAppointments.apptDate;
    map["apptTime"] = inAppointments.apptTime;
    return map;
  }

  //create an appointment
  Future create(Appointment inAppointment) async {
    Database db = await database;
    var val = await db.rawQuery(
        "SELECT MAX(id) + 1 AS id FROM appointments");
    int id = val.first["id"];
    if (id == null) {id = 1;}
    return await db.rawInsert(
        "INSERT INTO appointments (id, title, description, apptDate, apptTime) "
            "VALUES (?, ?, ?, ?, ?)",
        [inAppointment.id, inAppointment.title, inAppointment.description, inAppointment.apptDate, inAppointment.apptTime]
    );
  }

  //get an appointment
  Future<Appointment> get(int inID) async {
    Database db = await database;
    var rec = await db.query("appointments", where: "id = ?", whereArgs: [inID]);
    return apptFromMap(rec.first);

  }

  //get all appointments
  Future<List> getAll() async {
    Database db = await database;
    var recs = await db.query("appointments");
    return recs.isNotEmpty ? recs.map((m) => apptFromMap(m)).toList() : [ ];
  }

  //update an appointment
  Future update(Appointment inAppointment) async {
    Database db = await database;
    return await db.update("appointments", apptToMap(inAppointment), where: "id = ?", whereArgs: [inAppointment.id]);
  }

  //delete a appointment
  Future delete(int inID) async {
    Database db = await database;
    return await db.delete("appointments", where:  "id = ?", whereArgs: [inID]);
  }
}