import 'package:flutter/material.dart';

class FloatingBottomButton extends StatelessWidget {
  final Function onTap;
  final String text;

  const FloatingBottomButton({this.onTap, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30.0),
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0xFFe3f4ff),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
          ),
          BoxShadow(
            color: Colors.blue.withOpacity(0.6),
            spreadRadius: 1,
            blurRadius: 1,
          )
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
