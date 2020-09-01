import 'package:scoped_model/scoped_model.dart';

class BaseModel extends Model {
  //current page
  int stackIndex = 0;

  //list of entity
  List entityList = [];

  //editing entity
  var entityBeingEdited;

  //the date, that picked by user
  String chosenDate;

  //display the data by user choice
  void setChosenDate(String inDate) {
    print("## BaseModel.setChosenDate(): inDate = $inDate");
    chosenDate = inDate;
    notifyListeners();
  }

  //load data from database
  void loadData(String inEntityType, dynamic inDatabase) async {
    print("## ${inEntityType}Model.loadData()");
    entityList = await inDatabase.getAll();
    notifyListeners();
  }

}