import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'TasksDBWorker.dart';
import 'TasksModel.dart' show TasksModel, tasksModel;
import 'package:bullshit_organizer/utils.dart' as utils;

class TasksEntry extends StatelessWidget {
  final TextEditingController _descriptionEditingController = TextEditingController();

  //unique key for form
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  //constructor
  TasksEntry() {
    _descriptionEditingController.addListener(() {
      tasksModel.entityBeingEdited.description = _descriptionEditingController.text;
    });
  }

  @override
  Widget build(BuildContext inContext) {
    if (tasksModel.entityBeingEdited != null) {
      _descriptionEditingController.text = tasksModel.entityBeingEdited.description;
    }
    return ScopedModel(
      model: tasksModel,
      child: ScopedModelDescendant<TasksModel>(
        builder: (BuildContext inContext, Widget inChild, TasksModel inModel
        ) {
          return Scaffold(
            bottomNavigationBar: Padding(
              padding:
                EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Row(
                children: [
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      //get back to the screen
                      FocusScope.of(inContext).requestFocus(FocusNode());
                      inModel.setStackIndex(0);
                    }
                  ),
                  Spacer(),
                  FlatButton(
                    child: Text("Save"),
                    onPressed: () { _save(inContext, tasksModel);}
                  )
                ],
              )
            ),
            body: Form(
              key: _formkey,
              child: ListView(
                children: [
                  //description
                  ListTile(
                    leading: Icon(Icons.description),
                    title: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: InputDecoration(hintText: "Description"),
                      controller: _descriptionEditingController,
                      validator: (String inValue) {
                        if (inValue.length == 0) {
                          return "Please, enter description";
                        }
                        return null;
                      }
                    )
                  ),
                  ListTile(
                    leading: Icon(Icons.today),
                    title: Text("Due date"),
                    subtitle: Text(tasksModel.chosenDate == null ? "" : tasksModel.chosenDate),
                    trailing: IconButton(
                      icon: Icon(Icons.edit), color: Colors.blue,
                      onPressed: () async {
                        String chosenDate = await utils.selectDate(
                            inContext,
                            tasksModel,
                            tasksModel.entityBeingEdited.dueDate);
                        if (chosenDate != null) {
                          tasksModel.entityBeingEdited.dueDate = chosenDate;
                        }
                      }
                    )
                  )
                ],
              )
            )

          );
        }
      )
    );
  }

  //save task
  void _save(BuildContext inContext, TasksModel inModel) async {
    if (!_formkey.currentState.validate()) {
      return;
    }
    if (tasksModel.entityBeingEdited.id == null) {
      await TasksDBWorker.db.create(tasksModel.entityBeingEdited);
    } else {
      await TasksDBWorker.db.update(tasksModel.entityBeingEdited);
    }

    tasksModel.loadData("tasks", TasksDBWorker.db);
    inModel.setStackIndex(0);

    Scaffold.of(inContext).showSnackBar(
     SnackBar(
       backgroundColor: Colors.green,
       duration: Duration(seconds: 2),
       content: Text("Task saved")
     )
    );
  }
}