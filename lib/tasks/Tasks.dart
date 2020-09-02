import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'TasksModel.dart';
import 'TasksDBWorker.dart';
import 'TasksList.dart';
import 'TasksEntry.dart';

// Tasks screen
class Tasks extends StatelessWidget {
  //constructor
  Tasks() {
    print("#==# Tasks.constructor");
    tasksModel.loadData("tasks", TasksDBWorker.db);
  }

  Widget build(BuildContext inContext) {
    print("#==# Tasks.build()");
    return ScopedModel<TasksModel>(
        model: tasksModel,
        child: ScopedModelDescendant<TasksModel>(
            builder: (BuildContext inContext, Widget inChild, TasksModel inModel)
            {
              return IndexedStack(
                index: inModel.stackIndex,
                children: [TasksList(), TasksEntry()],
              );
            }
        )
    );
  }
}