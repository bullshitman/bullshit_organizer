import 'package:bullshit_organizer/model/BaseModel.dart';

class Appointment {
  int id;
  String title;
  String description;
  String apptDate;
  String apptTime;
  //overriding toString() for better debugging
  String toString() {
    return "{ id=$id, title=$title, content=$description} apptDate=$apptDate} apptTime=$apptTime}";
  }
}

//setup appt time
class AppointmentsModel extends BaseModel {
  String apptTime;
  void setApptTime(String inApptTime) {
    print("#=# Appointments.setApptTime(): inApptTime = $inApptTime");
    apptTime = inApptTime;
    notifyListeners();
  }
}

//singleton
AppointmentsModel appointmentsModel = AppointmentsModel();