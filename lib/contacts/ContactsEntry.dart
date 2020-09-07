import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bullshit_organizer/utils.dart' as utils;
import 'ContactsDBWorker.dart';
import 'ContactsModel.dart' show ContactsModel, contactsModel;

class ContactsEntry extends StatelessWidget {

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ContactsEntry() {
    _nameEditingController.addListener(() {
      contactsModel.entityBeingEdited.name = _nameEditingController.text;
    });

    _emailEditingController.addListener(() {
      contactsModel.entityBeingEdited.telephone = _phoneEditingController.text;
    });

    _emailEditingController.addListener(() {
      contactsModel.entityBeingEdited.email = _emailEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(contactsModel.entityBeingEdited != null) {
      _nameEditingController.text = contactsModel.entityBeingEdited.name;
      _emailEditingController.text = contactsModel.entityBeingEdited.email;
      _phoneEditingController.text = contactsModel.entityBeingEdited.telephone;
    }

    return ScopedModel(
      model: contactsModel,
      child: ScopedModelDescendant<ContactsModel>(
        builder: (BuildContext inContext, Widget inChild, ContactsModel inModel) {
          File avatarFile = File(join(utils.docsDir.path, "avatar"));
          if(avatarFile.existsSync() == false) {
            if(inModel.entityBeingEdited != null && inModel.entityBeingEdited.id != null) {
              avatarFile = File(join(utils.docsDir.path, inModel.entityBeingEdited.id.toString()));
            }
          }
          return Scaffold(
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Row(
                children: [
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      //delete avatar file if exist
                      File avatarFile = File(join(utils.docsDir.path, "avatar"));
                      if(avatarFile.existsSync()) {
                        avatarFile.deleteSync();
                      }
                      //get back to list and hide keyboard
                      FocusScope.of(inContext).requestFocus(FocusNode());
                      inModel.setStackIndex(0);
                    }
                  ),
                  Spacer(),
                  FlatButton(
                    child: Text("Save"),
                    onPressed: () {
                      _save(inContext, inModel);
                    }
                  )
                ]
              )
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                children: [
                  //avatar
                  ListTile(
                    title : avatarFile.existsSync() ? Image.file(avatarFile) : Text("No avatar"),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.blue,
                      onPressed: () => _selectAvatar(inContext)
                    )
                  ),
                  //name
                  ListTile(
                    leading: Icon(Icons.person),
                    title: TextFormField(
                      decoration: InputDecoration(hintText: "Name"),
                      controller: _nameEditingController,
                      validator: (String inValue) {
                        if(inValue.length == 0) {
                          return "Please, enter a name";
                        }
                        return null;
                      }
                    )
                  ),
                  //telephone
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _phoneEditingController,
                    )
                  ),
                  //email
                  ListTile(
                    leading: Icon(Icons.email),
                    title: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailEditingController,
                    )
                  ),
                  //birthday
                  ListTile(
                    leading: Icon(Icons.today),
                    title: Text("Birthday"),
                    subtitle: Text(contactsModel.chosenDate == null ? "" : contactsModel.chosenDate),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.blue,
                      onPressed: () async {
                        String chosenDate = await utils.selectDate(inContext, contactsModel, contactsModel.entityBeingEdited.birthday);
                        if(chosenDate != null) {
                          contactsModel.entityBeingEdited.birthday = chosenDate;
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

  Future _save(BuildContext inContext, ContactsModel inModel) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    var id;

    if(inModel.entityBeingEdited.id == null) {
      id = await ContactsDBWorker.db.create(contactsModel.entityBeingEdited);
    } else {
      id = contactsModel.entityBeingEdited.id;
      await ContactsDBWorker.db.update(contactsModel.entityBeingEdited);
    }

    //rename avatar file with id
    File avatarFile = File(join(utils.docsDir.path, "avatar"));
    if(avatarFile.existsSync()) {
      avatarFile.renameSync(join(utils.docsDir.path, id.toString()));
    }

    //reload list
    contactsModel.loadData("contacts", ContactsDBWorker.db);

    inModel.setStackIndex(0);
    Scaffold.of(inContext).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text("Contact saved"),
      )
    );
  }


}

Future _selectAvatar(BuildContext inContext) {
  return showDialog(context: inContext,
  builder: (BuildContext inDialogContext) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            //get a photo from camera
            GestureDetector(
              child: Text("Take a photo"),
              onTap: () async {
                var cameraImage = await ImagePicker.pickImage(source: ImageSource.camera);
                if(cameraImage != null) {
                  //Copy file
                  print("#==# Got image from camera");
                  cameraImage.copySync(join(utils.docsDir.path, "avatar"));
                  contactsModel.triggerRebuild();
                }
                Navigator.of(inDialogContext).pop();
              }
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            //get a photo from gallery
            GestureDetector(
              child: Text("Select from gallery"),
              onTap: () async {
                var galleryImage = await ImagePicker.pickImage(source: ImageSource.gallery);
                if(galleryImage != null) {
                  //copy image
                  print("#==# Got image from gallery");
                  galleryImage.copySync(join(utils.docsDir.path, "avatar"));
                  contactsModel.triggerRebuild();
                }
                Navigator.of(inDialogContext).pop();
              }
            )
          ],
        )
      )
    );
  }
  );
}