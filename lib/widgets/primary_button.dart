import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  final String btnText;
  final Function onTap;
  PrimaryButton({this.btnText, this.onTap});

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).buttonColor, borderRadius: BorderRadius.circular(50)),
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            widget.btnText,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
