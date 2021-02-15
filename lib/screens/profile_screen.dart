import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _pickedImage;
  final ImagePicker _picker = ImagePicker();
  FirebaseAuth auth = FirebaseAuth.instance;

  void _pickImage(ImageSource src) async {
    final pickedImageFile =
        await _picker.getImage(source: src, imageQuality: 40, maxWidth: 200);
    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });

    } else {
      print('no Image selected');
    }
  }

  String userImage;
  void getUserImage() async{
    FirebaseFirestore.instance
        .collection('user')
        .get()
        .then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        userImage = doc["imageUrl"];
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    getUserImage();
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
          ),
          Center(
            child: Stack(children: [
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey,
                backgroundImage:  _pickedImage != null ? FileImage(_pickedImage) : AssetImage('assets/images/user.png')
                      ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                    margin: EdgeInsets.only(right: 10),
                    width: 50,
                    height: 50,
                    child: new RawMaterialButton(
                      fillColor: Theme.of(context).buttonColor,
                      shape: new CircleBorder(),
                      elevation: 0.0,
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        displayBottomSheet(context);
                      },
                    )),
              )
            ]),
          ),
          SizedBox(height: 25),
          Text(
            'Mahmoud Ibrahim',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          SizedBox(height:MediaQuery.of(context).size.height*0.5),
          RaisedButton(
              child: Text('Save',style: TextStyle(color: Colors.white),),
              onPressed: () async {
                final ref = FirebaseStorage.instance
                    .ref()
                    .child('userImage')
                    .child(auth.currentUser.uid + "jpg");
                await ref.putFile(_pickedImage);
                var url = await ref.getDownloadURL();
                await FirebaseFirestore.instance
                    .collection('user')
                    .doc(auth.currentUser.uid)
                    .update({'imageUrl': url});
              })
        ],
      ),
    );
  }

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(22), topLeft: Radius.circular(22))),
        context: context,
        builder: (ctx) {
          return Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              height: MediaQuery.of(context).size.height * 0.25,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Profile Photo',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(right: 10),
                                width: 50,
                                height: 50,
                                child: new RawMaterialButton(
                                  fillColor: Theme.of(context).buttonColor,
                                  shape: new CircleBorder(),
                                  elevation: 0.0,
                                  child: Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _pickImage(ImageSource.camera);
                                  },
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Camera',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(right: 10),
                                width: 50,
                                height: 50,
                                child: new RawMaterialButton(
                                  fillColor: Theme.of(context).buttonColor,
                                  shape: new CircleBorder(),
                                  elevation: 0.0,
                                  child: Icon(
                                    Icons.photo_size_select_actual,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _pickImage(ImageSource.gallery);
                                  },
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Gallery',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }
}
