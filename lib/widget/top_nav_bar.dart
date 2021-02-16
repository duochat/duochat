import 'package:flutter/material.dart';

class TopNavBar extends StatelessWidget {
  final ImageProvider<dynamic> image;
  final String title;
  final Widget suffix;

  const TopNavBar({
    Key key,
    this.image,
    this.title,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        image != null
            ? Container(
                margin: EdgeInsets.all(16.0),
                child: Container(
                  child: CircleAvatar(
                    backgroundImage: image,
                  ),
                  width: 48.0,
                  height: 48.0,
                  padding: EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8.0,
                    )
                  ],
                ),
              )
            : SizedBox(
                width: 20.0,
                height: 80.0,
              ),
        Text(
          title,
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Flexible(
          child: Container(),
        ),
        suffix,
        SizedBox(
          width: 8.0,
        )
      ],
    );
  }
}
