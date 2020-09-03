import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'AppointmentsModel.dart';
import 'AppointmentsDBWorker.dart';
import 'AppointmentsList.dart';
import 'AppointmentEntry.dart';

//Appointments screen
class Appointments extends StatelessWidget {
  //constructor
  Appointments() {
    print("#==# Appointments.constructor");
    appointmentsModel.loadData("appointments", AppointmentsDBWorker.db);
  }

  @override
  Widget build(BuildContext context) {
    print("#==# Appointments.build()");
    return ScopedModel<AppointmentsModel>(
      model: appointmentsModel,
      child: ScopedModelDescendant<AppointmentsModel>(
        builder: (BuildContext inContext, Widget inChild, AppointmentsModel inModel)
            {
              return IndexedStack(
                index: inModel.stackIndex,
                children: [AppointmentsList(), AppointmentsEntry()],
              );
            }
      )
    );
  }
}