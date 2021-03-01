import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting/screens/photo_view_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
import 'package:intl/intl.dart';

class Messages extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final bool isMe;
  final String receiverId;

  Messages({Key key, this.isMe, this.receiverId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ));
          } else {
            final docs = snapshot.data.docs;
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                reverse: true,
                itemCount: docs.length,
                itemBuilder: (ctx, index) {
                  if ((docs[index]['receiverId'] == auth.currentUser.uid &&
                          docs[index]['senderId'] == receiverId) ||
                      (docs[index]['senderId'] == auth.currentUser.uid &&
                          docs[index]['receiverId'] == receiverId) ||
                      (docs[index]['senderId'] == auth.currentUser.uid &&
                          docs[index]['receiverId'] == auth.currentUser.uid)) {
                    Timestamp time = docs[index]['time'];
                    String formatedTime =
                        DateFormat('hh:mm').format(time.toDate());
                    if (docs[index]['senderId'] == auth.currentUser.uid) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: docs[index]['messageImageUrl'] == null
                                  ? () {}
                                  : () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) => ImageViewScreen(
                                                    imageUrl: docs[index]
                                                        ['messageImageUrl'],
                                                  )));
                                    },
                              child: ChatBubble(
                                elevation: 0,
                                clipper: ChatBubbleClipper4(
                                    type: BubbleType.sendBubble),
                                alignment: Alignment.topRight,
                                //margin: EdgeInsets.only(top: 20),
                                backGroundColor: Theme.of(context).buttonColor,
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.7,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      docs[index]['messageImageUrl'] == null
                                          ? Text(
                                              docs[index]['text'],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: docs[index]
                                                  ['messageImageUrl'],
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        formatedTime,
                                        style: TextStyle(
                                            color: Colors.white38,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              backgroundImage: docs[index]['imageUrl'] == null
                                  ? AssetImage('assets/images/sam.jpg')
                                  : NetworkImage(docs[index]['imageUrl']),
                            ),
                            SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              backgroundImage: docs[index]['imageUrl'] == null
                                  ? AssetImage('assets/images/sam.jpg')
                                  : NetworkImage(docs[index]['imageUrl']),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ChatBubble(
                              elevation: 0,
                              clipper: ChatBubbleClipper4(
                                  type: BubbleType.receiverBubble),
                              alignment: Alignment.topRight,
                              //margin: EdgeInsets.only(top: 20),
                              backGroundColor: Theme.of(context).accentColor,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    docs[index]['messageImageUrl'] == null
                                        ? Text(
                                            docs[index]['text'],
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: docs[index]
                                                ['messageImageUrl'],
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      formatedTime,
                                      style: TextStyle(
                                          color: Colors.white38, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    return null;
                  }
                });
          }
        });
  }
}
