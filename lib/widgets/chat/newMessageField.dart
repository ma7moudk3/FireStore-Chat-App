import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewMessageField extends StatefulWidget {
  final String receiverId;

  const NewMessageField({Key key, this.receiverId}) : super(key: key);
  @override
  _NewMessageFieldState createState() => _NewMessageFieldState();
}

class _NewMessageFieldState extends State<NewMessageField> {
  File _pickedImage;
  final ImagePicker _picker = ImagePicker();

  void _pickImage(ImageSource src) async {
    final pickedImageFile =
        await _picker.getImage(source: src, imageQuality: 80, maxWidth: 600);
    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
      final userData = await FirebaseFirestore.instance
          .collection('user')
          .doc(auth.currentUser.uid)
          .get();
      final ref = FirebaseStorage.instance
          .ref()
          .child('messagesImages')
          .child(auth.currentUser.uid + "jpg");
      await ref.putFile(_pickedImage);
      var url = await ref.getDownloadURL();
      FirebaseFirestore.instance.collection('chat').add({
        'text': _controller.text,
        'time': Timestamp.now(),
        'messageImageUrl': url,
        'imageUrl': userData['imageUrl'],
        'senderId': auth.currentUser.uid,
        'receiverId': widget.receiverId
      });
    } else {
      print('no Image selected');
    }
  }

  final _controller = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  String message = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 85,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  message = value;
                });
              },
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: 'Send a message',
                  border: new OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  prefixIcon: InkWell(
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(
                        Icons.photo,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).primaryColor,
                  suffixIcon: Container(
                      margin: EdgeInsets.only(right: 10),
                      width: 42.0,
                      height: 42.0,
                      child: new RawMaterialButton(
                        fillColor: Theme.of(context).buttonColor,
                        shape: new CircleBorder(),
                        elevation: 0.0,
                        child: Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          sendMessage();
                        },
                      ))),
            ),
          ),
        ],
      ),
    );
  }

  sendMessage() async {
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(auth.currentUser.uid)
        .get();
    if (message.isNotEmpty) {
      FirebaseFirestore.instance.collection('chat').add({
        'text': _controller.text,
        'time': Timestamp.now(),
        'username': userData['username'],
        'imageUrl': userData['imageUrl'],
        'messageImageUrl': null,
        'senderId': auth.currentUser.uid,
        'receiverId': widget.receiverId
      });
      _controller.clear();
    }
  }
}
