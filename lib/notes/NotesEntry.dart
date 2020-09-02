import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'NotesDBWorker.dart';
import 'NotesModel.dart' show NotesModel, notesModel;

class NotesEntry extends StatelessWidget {

  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditionController = TextEditingController();

  //unique key for form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //constructor
  NotesEntry() {
    _titleEditingController.addListener(() {
      notesModel.entityBeingEdited.title = _titleEditingController.text;
    });
    _contentEditionController.addListener(() {
      notesModel.entityBeingEdited.content = _contentEditionController.text;
    });
  }

  @override
  Widget build(BuildContext inContext) {
    _titleEditingController.text = notesModel.entityBeingEdited.title;
    _contentEditionController.text = notesModel.entityBeingEdited.content;

    return ScopedModel(
      model: notesModel,
      child: ScopedModelDescendant<NotesModel>(
        builder: (BuildContext inContext, Widget inChild, NotesModel inModel
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
                      //hide keyboard
                      FocusScope.of(inContext).requestFocus(FocusNode());
                      //back to the note list
                      inModel.setStackIndex(0);
                    }
                  ),
                  Spacer(),
                  FlatButton(
                    child: Text("Save"),
                    onPressed: () { _save(inContext, notesModel); }
                  )
                ]
              )
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                children: [
                  //title
                  ListTile(
                    leading: Icon(Icons.title),
                    title: TextFormField(
                      decoration: InputDecoration(hintText: "Title"),
                      controller: _titleEditingController,
                      validator: (String inValue) {
                        if (inValue.length == 0) {
                          return "Please, enter a title";
                        }
                        return null;
                      }
                    )
                  ),
                  //content
                  ListTile(
                    leading: Icon(Icons.content_paste),
                    title: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      decoration: InputDecoration(hintText: "Content"),
                      controller: _contentEditionController,
                      validator: (String inValue) {
                        if (inValue.length == 0) { return "Please, enter content";}
                        return null;
                      }
                    )
                  ),
                  //notes colors
                  ListTile(
                    leading: Icon(Icons.color_lens),
                    title: Row(
                      children: [
                        GestureDetector(
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: Border.all(width: 18, color: Colors.red) +
                              Border.all(width: 6,
                              color: notesModel.color == "red" ? Colors.red : Theme.of(inContext).canvasColor)
                            )
                          ),
                          onTap: () {
                            notesModel.entityBeingEdited.color = "red";
                            notesModel.setColor("red");
                          }
                        ),
                        Spacer(),
                        GestureDetector(
                            child: Container(
                                decoration: ShapeDecoration(
                                    shape: Border.all(width: 18, color: Colors.green) +
                                        Border.all(width: 6,
                                            color: notesModel.color == "green" ? Colors.green : Theme.of(inContext).canvasColor)
                                )
                            ),
                            onTap: () {
                              notesModel.entityBeingEdited.color = "green";
                              notesModel.setColor("green");
                            }
                        ),
                        Spacer(),
                        GestureDetector(
                            child: Container(
                                decoration: ShapeDecoration(
                                    shape: Border.all(width: 18, color: Colors.blue) +
                                        Border.all(width: 6,
                                            color: notesModel.color == "blue" ? Colors.blue : Theme.of(inContext).canvasColor)
                                )
                            ),
                            onTap: () {
                              notesModel.entityBeingEdited.color = "blue";
                              notesModel.setColor("blue");
                            }
                        ),
                        Spacer(),
                        GestureDetector(
                            child: Container(
                                decoration: ShapeDecoration(
                                    shape: Border.all(width: 18, color: Colors.yellow) +
                                        Border.all(width: 6,
                                            color: notesModel.color == "yellow" ? Colors.yellow : Theme.of(inContext).canvasColor)
                                )
                            ),
                            onTap: () {
                              notesModel.entityBeingEdited.color = "yellow";
                              notesModel.setColor("yellow");
                            }
                        ),
                        Spacer(),
                        GestureDetector(
                            child: Container(
                                decoration: ShapeDecoration(
                                    shape: Border.all(width: 18, color: Colors.grey) +
                                        Border.all(width: 6,
                                            color: notesModel.color == "grey" ? Colors.grey : Theme.of(inContext).canvasColor)
                                )
                            ),
                            onTap: () {
                              notesModel.entityBeingEdited.color = "grey";
                              notesModel.setColor("grey");
                            }
                        ),
                        Spacer(),
                        GestureDetector(
                            child: Container(
                                decoration: ShapeDecoration(
                                    shape: Border.all(width: 18, color: Colors.purple) +
                                        Border.all(width: 6,
                                            color: notesModel.color == "purple" ? Colors.purple : Theme.of(inContext).canvasColor)
                                )
                            ),
                            onTap: () {
                              notesModel.entityBeingEdited.color = "purple";
                              notesModel.setColor("purple");
                            }
                        ),
                      ],
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

  void _save(BuildContext inContext, NotesModel inModel) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    if (inModel.entityBeingEdited.id == null) {
      //create a new note
      await NotesDBWorker.db.create(notesModel.entityBeingEdited);
    } else {
      //update existing note
      await NotesDBWorker.db.update(notesModel.entityBeingEdited);
    }

    //reload notes list
    notesModel.loadData("notes", NotesDBWorker.db);
    inModel.setStackIndex(0);
      Scaffold.of(inContext).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          content: Text("Note saved"),
        )
      );
  }
}