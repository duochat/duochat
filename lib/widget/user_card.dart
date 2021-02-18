import 'package:flutter/material.dart';
import 'package:duochat/models.dart';

class UserCard extends StatelessWidget {

  final PublicUserData user;
  final String message;
  final Widget contextWidget;
  final Function onTap;

  UserCard({
    this.user,
    this.message = "",
    this.contextWidget = const SizedBox(),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFFFFFFEF), const Color(0xFFffd4d1)],
          ),
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(25.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 35.0,
              backgroundImage: NetworkImage(user.photoURL),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    user.name,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    width: MediaQuery.of(context).size.width - 210,
                    child: Text(
                      message,
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.0),
            contextWidget,
          ],
        ),
      ),
    );
  }

}