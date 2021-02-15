import 'package:chatting/widgets/outline_button.dart';
import 'package:chatting/widgets/primary_button.dart';
import 'package:chatting/widgets/text_field_with_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //fireBase
  FirebaseAuth auth = FirebaseAuth.instance;

  //
  double windowWidth = 0;
  double windowHight = 0;
  double _loginOffsit = 0;
  double _registerOffsit = 0;
  double _loginXoffsit = 0;
  double _loginWidth = 0;
  Color loginColor = Colors.white;
  int _pageState = 0;

// Login And registration
  String signupEmail;
  String signupPassword;
  String signUpUserName;
  String loginEmail;
  String loginPassword;
  //
  final _registerFormKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    //signUp();
    windowHight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    var _backgroundColor = Theme.of(context).primaryColor;
    var _headingColor = Colors.white;
    switch (_pageState) {
      case 0:
        _backgroundColor = Theme.of(context).primaryColor;
        _loginOffsit = windowHight;
        _registerOffsit = windowHight;
        _loginXoffsit = 0;
        _loginWidth = windowWidth;
        loginColor = Colors.white;
        break;
      case 1:
        _backgroundColor =Theme.of(context).primaryColor;
        _headingColor = Colors.white;
        _loginOffsit = 270;
        _registerOffsit = windowHight;
        _loginXoffsit = 0;
        _loginWidth = windowWidth;
        loginColor = Theme.of(context).accentColor;
        break;
      case 2:
        _backgroundColor = Theme.of(context).primaryColor;
        _headingColor = Colors.white;
        _loginOffsit = 250;
        _registerOffsit = 270;
        _loginXoffsit = 20;
        _loginWidth = windowWidth - 40;
        loginColor =Color(0x7048495E);

        break;
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                _pageState = 0;
              });
            },
            child: AnimatedContainer(
              curve: Curves.fastLinearToSlowEaseIn,
              color: _backgroundColor,
              duration: Duration(milliseconds: 500),
              child: SizedBox.expand(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 97, bottom: 15),
                      child: Text(
                        'Chat App',
                        style: TextStyle(
                          fontSize: 28,
                          color: _headingColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 260.0,
                      height: 130.0,
                      child: Text(
                        'Connect with friends and family at any time, with our comprehensive free app',
                        style: TextStyle(
                          fontSize: 16,
                          color: _headingColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Image.asset(
                      'assets/images/splashimage.png',
                      width: 300,
                      height: 300,
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_pageState != 0)
                            _pageState = 0;
                          else
                            _pageState = 1;
                        });
                      },
                      child: Container(
                          padding: EdgeInsets.all(20),
                          width: 350.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(27.0),
                            color: Theme.of(context).buttonColor,
                          ),
                          child: Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _pageState = 2;
              });
            },
            child: AnimatedContainer(
              width: _loginWidth,
              duration: Duration(milliseconds: 1000),
              curve: Curves.fastLinearToSlowEaseIn,
              transform:
                  Matrix4.translationValues(_loginXoffsit, _loginOffsit, 0),
              decoration: BoxDecoration(
                  color: loginColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Padding(
                padding: const EdgeInsets.only(top: 55, left: 25, right: 25),
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[

                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Text(
                              "Login To Continue",
                              style: TextStyle(fontSize: 20,color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          InputWithIcon(
                              icon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                              hint: "Enter Email...",
                              onSaved: (value) {
                                loginEmail = value;
                              },
                              validator: (String val) {
                                if (val.isEmpty || !val.contains('@')) {
                                  return "please Enter A valid email Address";
                                }
                                return null;
                              }),
                          SizedBox(
                            height: 20,
                          ),
                          InputWithIcon(
                              icon: Icons.vpn_key,
                              keyboardType: TextInputType.visiblePassword,
                              hint: "Enter Password...",
                              obscureText: true,
                              onSaved: (value) {
                                loginPassword = value;
                              },
                              validator: (String val) {
                                if (val.isEmpty || val.length < 7) {
                                  return "password should be at least 7 charcters";
                                }
                                return null;
                              })
                        ],
                      ),

                      SizedBox(
                        height: 55,
                      ),
                      if(_isLoading)
                        CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      if(!_isLoading)
                      Column(
                        children: <Widget>[
                          PrimaryButton(
                            btnText: "Login",
                            onTap: () {
                              _submit();
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _pageState = 2;
                              });
                            },
                            child: OutlineBtn(
                              btnText: "Create New Account",
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _pageState = 1;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              curve: Curves.fastLinearToSlowEaseIn,
              transform: Matrix4.translationValues(0, _registerOffsit, 0),
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Padding(
                padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
                child: Form(
                  key: _registerFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Text(
                              "Create New Account",
                              style: TextStyle(fontSize: 20,color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          InputWithIcon(
                            keyboardType: TextInputType.emailAddress,
                              icon: Icons.email,
                              hint: "Enter Your Email",
                              onSaved: (value) {
                                signupEmail = value;
                              },
                              validator: (String val) {
                                if (val.isEmpty || !val.contains('@')) {
                                  return "please Enter A valid email Address";
                                }
                                return null;
                              }),
                          SizedBox(
                            height: 20,
                          ),
                          InputWithIcon(
                            icon: Icons.person,
                            keyboardType: TextInputType.text,
                            hint: "Enter UserName",
                            onSaved: (value) {
                              signUpUserName = value;
                            },
                            validator: (String val) {
                              if (val.isEmpty || val.length < 4) {
                                return "please Enter at least four charcters";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InputWithIcon(
                              icon: Icons.vpn_key,
                              keyboardType: TextInputType.visiblePassword,
                              hint: "Enter Your Password",
                              obscureText: true,
                              onSaved: (value) {
                                signupPassword = value;
                              },
                              validator: (String val) {
                                if (val.isEmpty || val.length < 7) {
                                  return "password should be at least 7 charcters";
                                }
                                return null;
                              })
                        ],
                      ),
                      SizedBox(
                        height: 23,
                      ),
                      if(!_isLoading)
                      Column(
                        children: <Widget>[
                          PrimaryButton(
                            btnText: "Signup",
                            onTap: () {
                              _submit();
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _pageState = 2;
                              });
                            },
                            child: OutlineBtn(
                              btnText: "Login",
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                      if(_isLoading)
                        CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _submit() {
    final isValid1 = _registerFormKey.currentState.validate();
    final isValid2 = _loginFormKey.currentState.validate();
    FocusScope.of(context).unfocus();
    // يعمل إغلاق للكيبورد عشان م يضل طالع للليوزر
    if (isValid1) {
      _registerFormKey.currentState.save();
      _submitAuthForm(signupEmail.trim(), signUpUserName.trim(), signupPassword,
          context, 2);
    } else if (isValid2) {
      _loginFormKey.currentState.save();
      _submitAuthForm(loginEmail.trim(), '', loginPassword, context, 1);
    }
  }

  void _submitAuthForm(String email, String userName, String password,
      BuildContext buildContext, int pageState) async {
    final _auth = FirebaseAuth.instance;
    UserCredential authResault;
    try {
      setState(() {
        _isLoading = true;
      });
      if (pageState == 1) {
        authResault = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

      } else if (pageState == 2) {
        authResault = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await  FirebaseFirestore.instance
            .collection('user')
            .doc(authResault.user.uid)
            .set({
          'username':userName,
          'email':email,
          'uid': auth.currentUser.uid,
          'imageUrl' :null
        });
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(buildContext).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }
}
