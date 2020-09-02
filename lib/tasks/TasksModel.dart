import 'package:bullshit_organizer/model/BaseModel.dart';

class Task {
  int id;
  String description;
  String dueDate;
  String completed = "false";
  //overriding toString() for better debugging
  String toString() {
    return "{ id=$id, description=$description, dueDate=$dueDate, completed=$completed}";
  }
}

//empty class
class TasksModel extends BaseModel {
}

//singleton
TasksModel tasksModel = TasksModel();