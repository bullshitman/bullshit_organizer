import 'package:bullshit_organizer/appointments/Appointments.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'utils.dart' as utils;
import 'package:bullshit_organizer/notes/Notes.dart';
import 'package:bullshit_organizer/tasks/Tasks.dart';
import 'contacts/Contacts.dart';

//Start point
void main() {
  print("#=# main() FlutterOrganizer starting");
  WidgetsFlutterBinding.ensureInitialized();
  startMeUp() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    utils.docsDir = docsDir;
    runApp(FlutterOrganizer());
  }
  startMeUp();
}//end main()

//main app widget

class FlutterOrganizer extends StatelessWidget {
  Widget build(BuildContext inContext) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text("FlutterOrganizer"),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.date_range),
                text: "Appointments"),
                Tab(icon: Icon(Icons.contacts),
                text: "Contacts"),
                Tab(icon: Icon(Icons.note),
                text: "Notes"),
                Tab(icon: Icon(Icons.assignment_turned_in),
                text: "Tasks"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Appointments(),
              Contacts(),
              Notes(),
              Tasks()
            ],
          )
        ),
      )
    );
  } //end build
} //end class
