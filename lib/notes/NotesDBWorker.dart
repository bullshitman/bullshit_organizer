import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bullshit_organizer/utils.dart' as utils;
import 'NotesModel.dart';

class NotesDBWorker {
  NotesDBWorker._();
  static final NotesDBWorker db = NotesDBWorker._();

  Database _db;

  // database instance
  Future get database async {
    if (db == null) {
      _db = await init();
    }
    return _db;
  }

  //database initialization
  Future<Database> init() async {
    String path = join(utils.docsDir.path, "notes.db");
    Database db = await openDatabase(
        path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
          await inDB.execute(
              "CREATE TABLE IF NOT EXIST notes ("
              "id INTEGER PRIMARY KEY,"
              "title TEXT,"
              "content TEXT,"
              "color TEXT"
              ")"
          );
        }
    );
    return db;
  }
  //converting note from a map
  Note noteFromMap(Map inMap) {
    Note note = Note();
    note.id = inMap["id"];
    note.title = inMap["title"];
    note.color = inMap["color"];
    note.content = inMap["content"];
    return note;
  }

  /*
  CONVERTING VEGETARIANS !..!_
  */

  //converting map from a note
  Map<String, dynamic> noteToMap(Note inNote) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inNote.id;
    map["title"] = inNote.title;
    map["color"] = inNote.color;
    map["content"] = inNote.content;
    return map;
  }

  //create a note
  Future create(Note inNote) async {
    Database db = await database;
    var val = await db.rawQuery(
      "SELECT MAX(id) + 1 AS id FROM notes");
    int id = val.first["id"];
    if (id == null) {id = 1;}
    return await db.rawInsert(
      "INSERT INTO notes (id, title, content, color) "
          "VALUES (?, ?, ?, ?)",
      [inNote.id, inNote.title, inNote.content, inNote.color]
    );
  }

  //get a note
  Future<Note> get(int inID) async {
    Database db = await database;
    var rec = await db.query("notes", where: "id = ?", whereArgs: [inID]);
    return noteFromMap(rec.first);

  }

  //get all notes
  Future<List> getAll() async {
    Database db = await database;
    var recs = await db.query("notes");
    return recs.isNotEmpty ? recs.map((m) => noteFromMap(m)).toList() : [ ];
  }

  //update a note
  Future update(Note inNote) async {
    Database db = await database;
    return await db.update("notes", noteToMap(inNote), where: "id = ?", whereArgs: [inNote.id]);
  }

  //delete a note
  Future delete(int inID) async {
    Database db = await database;
    return await db.delete("notes", where:  "id = ?", whereArgs: [inID]);
  }
}