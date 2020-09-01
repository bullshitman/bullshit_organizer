import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'NotesModel.dart';
import 'NotesDBWorker.dart';
import 'NotesList.dart';
import 'NotesEntry.dart';

// Notes screen
class Notes extends StatelessWidget {
  Notes() {
    print("## Notes.constructor");
    notesModel.loadData("notes", NotesDBWorker.db);
  }

  Widget build(BuildContext inContext) {
    print("## Notes.build()");
    return ScopedModel<NotesModel>(
      model: notesModel,
      child: ScopedModelDescendant<NotesModel>(
        builder: (BuildContext inContext, Widget inChild, NotesModel inModel)
            {
              return IndexedStack(
                index: inModel.stackIndex,
                children: [NotesList(), NotesEntry()],
              );
            }
      )
    );
  }
}