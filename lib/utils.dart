import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'model/BaseModel.dart';

//app directory
Directory docsDir;

//Future for selected date
Future selectDate(
    BuildContext inContext,
    BaseModel inModel,
    String inDateString
) async {
  print("#=# selectDate()");
  //default date
  DateTime initialDate = DateTime.now();
  //if it was edit
  if (inDateString != null) {
    List dateParts = inDateString.split(",");
    initialDate = DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2])
    );
  }

  //request the date
  DateTime picked = await showDatePicker(context: inContext, initialDate: initialDate, firstDate: DateTime(1900), lastDate: DateTime(2100));

  //if did't cancel, updating
  if (picked != null) {
    inModel.setChosenDate(DateFormat.yMMMMd("en_US").format(picked.toLocal()));
    return "${picked.year},${picked.month},${picked.day}";
  }

}