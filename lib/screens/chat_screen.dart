import 'package:chatting/widgets/chat/messages.dart';
import 'package:chatting/widgets/chat/newMessageField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String userName;
  final String userImage;

  const ChatScreen({Key key, this.receiverId, this.userName, this.userImage})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  // void getUserImage() async {
  //   FirebaseFirestore.instance
  //       .collection('user')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) => {
  //             querySnapshot.docs.forEach((doc) {
  //               if (doc["uid"] == FirebaseAuth.instance.currentUser.uid)
  //
  //             })
  //           });
  // }

  Widget build(BuildContext context) {
    // getUserImage();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: CircleAvatar(
              radius: 20.0, backgroundImage: NetworkImage(widget.userImage)),
        ),
        title: Text(widget.userName),
        actions: [
          DropdownButton(
            underline: Container(),
            onChanged: (itemIdentifier) async {
              if (itemIdentifier == 'logout') {
                await FirebaseAuth.instance.signOut();
              }
            },
            icon: Icon(
              Icons.more_horiz_rounded,
              color: Colors.white,
            ),
            items: [
              DropdownMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Logout')
                  ],
                ),
                value: 'logout',
              )
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              flex: 5,
              child: Container(child: Messages(receiverId: widget.receiverId))),
          Expanded(
            flex: 0,
            child: NewMessageField(
              receiverId: widget.receiverId,
            ),
          )
        ],
      ),
    );
  }
}
