import 'package:bullshit_organizer/model/BaseModel.dart';

class Note {
  int id;
  String title;
  String content;
  String color;
  //overriding toString() for better debugging
  String toString() {
    return "{ id=$id, title=$title, content=$content}";
  }
}

//setup users color
class NotesModel extends BaseModel {
  String color;
  void setColor(String inColor) {
    print("#=# Notes.setColor(): inColor = $inColor");
    color = inColor;
    notifyListeners();
  }
}

//singleton
NotesModel notesModel = NotesModel();