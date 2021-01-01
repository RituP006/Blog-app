import 'dart:io'; // enables user to attach image files

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'homepage.dart';

class UploadPhotoPage extends StatefulWidget {
  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  File sampleImage;
  String _myvalue;
  String imageUrl;
  final formKey = GlobalKey<FormState>();

  Future getImage() async {
    var tempimage = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = File(tempimage.path);
    });
  }

  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void uploadStatusImage() async {
    print('started uploadstatus');
    if (validateAndSave()) {
      // final Reference postImageRef =
      //     FirebaseStorage.instance.ref().child('Post Images');

      // // creating a unique key foe every image so that it's not replaced by same name.
      //

      // // uploading image with unique id in Post Image reference
      //
      //
      // // To store in firebase database
      // // 1. get image url
      // imageUrl = (await postImageRef.getDownloadURL()).toString();
      // // Uri imageUrl = (await uploadTask.future).downloadUrl;

      final Reference _storage =
          FirebaseStorage.instance.ref().child('Post Images');
      var timeKey = DateTime.now();
      final UploadTask uploadTask =
          _storage.child(timeKey.toString() + '.jpg').putFile(sampleImage);
      // await _storage.child(timeKey.toString() + '.jpg').putFile(sampleImage);
      imageUrl = await (await uploadTask).ref.getDownloadURL();
      print('image Url' + imageUrl);
      goToHomePage();
      saveToDatabase(imageUrl.toString());
    }
  }

  void saveToDatabase(url) {
    // database unique key for each data
    var dbTimeKey = DateTime.now();

    var formatDate = DateFormat('MMM d,yyy');
    var formatTime = DateFormat('EEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    // dataobject
    var data = {
      'image': url,
      'description': _myvalue,
      'date': date,
      'time': time,
    };

    ref.child('Posts').push().set(data);
  }

  void goToHomePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
        centerTitle: true,
      ),
      body: Center(
        child: sampleImage == null ? Text('Select an Image') : enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget enableUpload() {
    return SingleChildScrollView(
      child: Container(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Image.file(
                sampleImage,
                height: 330.0,
                width: 660.0,
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  return value.isEmpty ? 'Blog Description is required' : null;
                },
                onSaved: (value) {
                  return _myvalue = value;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              RaisedButton(
                elevation: 10.0,
                child: Text('Add new post'),
                textColor: Colors.white,
                // color: Theme.of(context).accentColor,
                onPressed: uploadStatusImage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
