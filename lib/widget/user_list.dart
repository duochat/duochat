import 'package:duochat/models.dart';
import 'package:flutter/material.dart';
import 'user_card.dart';

class ConnectionRequestList extends StatelessWidget {

  final List<PublicUserData> requests;

  ConnectionRequestList({
    Key key,
    this.requests,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (BuildContext context, int index) {
          return UserCard(
            user: requests[index],
            message: requests[index].username,
            contextWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RawMaterialButton(
                  shape: StadiumBorder(),
                  child: Text("Accept"),
                  fillColor: Colors.green,
                  elevation: 0,
                  onPressed: () { print("accepted connection request from ${requests[index].username}"); },
                ),
                RawMaterialButton(
                  shape: StadiumBorder(),
                  child: Text("Reject"),
                  fillColor: Colors.red,
                  elevation: 0,
                  onPressed: () { print("rejected connection request from ${requests[index].username}"); },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}


class UserSearchList extends StatelessWidget {

  final List<PublicUserData> results;

  UserSearchList({
    Key key,
    this.results,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (BuildContext context, int index) {
          return UserCard(
            user: results[index],
            message: results[index].username,
            onTap: () {
              //TODO show profile page
              print("show ${results[index].username} profile page");
            },
          );
        },
      ),
    );
  }
  
}