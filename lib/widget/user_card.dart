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
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFFFFE0B0), const Color(0xFFFFF0D0)],
          ),
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(25.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            user.photoURL != null
            ? Container(
              child: CircleAvatar(
                radius: 35.0,
                backgroundImage: NetworkImage(user.photoURL),
              ),
              padding: EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8.0,
                  )
                ],
              ),
            ) : SizedBox(width: 0),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    user.name,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  message != ''
                  ? Container(
                    //width: MediaQuery.of(context).size.width - 210,
                    child: Text(
                      message,
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ) : SizedBox(height: 0),
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