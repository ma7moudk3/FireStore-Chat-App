import 'dart:ui';

import 'package:flutter/material.dart';

class InputWithIcon extends StatefulWidget {
  final IconData icon;
  final String hint;
  final bool obscureText;
  final Function onSaved;
  final Function validator;
  final TextInputType keyboardType;
  InputWithIcon({this.icon, this.hint, this.onSaved, this.validator, this.obscureText, this.keyboardType});

  @override
  _InputWithIconState createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10,right: 10,bottom: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
       //   border: Border.all(color: Color(0xFFBC7C7C7), width: 2),
          borderRadius: BorderRadius.circular(50)),
      child: Row(
        children: <Widget>[
         Container(
                width: 60,
                child: Icon(
                  widget.icon,
                  size: 22,
                  color: Color(0xFF90939C),
                )),
          Container(
            width: 250,
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              keyboardType: widget.keyboardType,
              cursorColor: Theme.of(context).primaryColor,
              obscureText: widget.obscureText == null ? false : widget.obscureText ,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  hintStyle: TextStyle(
                    color: Theme.of(context).accentColor
                  ),
                  hintText: widget.hint,

              ),
              onSaved: (value) {
                widget.onSaved(value);
              },
              validator: (value) =>
                widget.validator(value)
              ,
            ),
          )
        ],
      ),
    );
  }
}
