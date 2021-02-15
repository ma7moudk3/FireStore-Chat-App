import 'dart:ui';
import 'package:animated_drawer/views/animated_drawer.dart';
import 'package:chatting/screens/chat_screen.dart';
import 'package:chatting/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchValue;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return AnimatedDrawer(
        openIcon: Padding(
          padding: const EdgeInsets.only(top: 5, right: 10, left: 15),
          child: Icon(
            Icons.menu_open,
            color: Colors.white,
          ),
        ),
        closeIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        shadowColor: Color(0x090272D3D),
        backgroundGradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).accentColor
          ],
        ),
        homePageXValue: 150,
        homePageYValue: 80,
        homePageAngle: -0.1,
        homePageSpeed: 250,
        shadowXValue: 122,
        shadowYValue: 110,
        shadowAngle: -0.175,
        shadowSpeed: 550,
        menuPageContent: Padding(
            padding: const EdgeInsets.only(top: 120.0, right: 180, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 80),
                  child: Image.asset(
                    'assets/images/drawer_image.png',
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                ),
                SizedBox(
                  height: 110,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 40),
                ),
                Text(
                  "Home Screen",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ProfileScreen()));
                  },
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                Divider(
                  color: Colors.white38,
                  thickness: 2,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                Text(
                  "About",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                Text(
                  "Share App",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                Divider(
                  color: Colors.white38,
                  thickness: 2,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                InkWell(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )),
        homePageContent: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: theme.primaryColor,
              title: Text(
                '       My Chat',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              // actions: [
              //   IconButton(
              //       icon: Icon(Icons.group_rounded),
              //       onPressed: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (ctx) => ChatScreen(
              //                       receiverId: "all",
              //                     )));
              //       }),
              // ],
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 15.0, left: 15, bottom: 10, top: 10),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        searchValue = value;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(17),
                          hintStyle: TextStyle(color: Colors.white24),
                          hintText: 'Search Contact',
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: theme.accentColor,
                          suffixIcon: Container(
                              margin: EdgeInsets.only(right: 10),
                              width: 39.0,
                              height: 39.0,
                              child: new RawMaterialButton(
                                fillColor: Theme.of(context).primaryColor,
                                shape: new CircleBorder(),
                                elevation: 0.0,
                                child: Icon(
                                  Icons.search_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  searchData(searchValue);
                                },
                              ))),
                    ),
                  ),
                  StreamBuilder(
                    stream: (searchValue == "" || searchValue == null)
                        ? FirebaseFirestore.instance
                            .collection('user')
                            .snapshots()
                        : searchData(searchValue),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ));
                      } else {
                        final docs = snapshot.data.docs;
                        return ListView.builder(
                            itemCount: docs.length,
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) => ChatScreen(
                                                receiverId: docs[index]['uid'],
                                                userName: docs[index]
                                                    ['username'],
                                                userImage: docs[index]
                                                    ['imageUrl'],
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15.0, left: 15, top: 8),
                                  child: ListTile(
                                      title: Text(
                                        docs[index]['username'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            docs[index]['imageUrl']),
                                      ),
                                      subtitle: Text(
                                        docs[index]['email'],
                                        style: TextStyle(color: Colors.white38),
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 18,
                                      )),
                                ),
                              );
                            });
                      }
                    },
                  ),
                ],
              ),
            )));
  }

  Stream<QuerySnapshot> stream() async* {
    var _stream = FirebaseFirestore.instance.collection('user').snapshots();
    yield* _stream;
  }

  Stream<QuerySnapshot> searchData(String string) async* {
    var firestore = FirebaseFirestore.instance;
    var _search = firestore
        .collection('user')
        .where('username', isGreaterThanOrEqualTo: string)
        .where('username', isLessThan: string + 'z')
        .snapshots();
    yield* _search;
  }
}
