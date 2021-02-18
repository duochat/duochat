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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: Icon(Icons.check),
                  onPressed: () => print("accepted connection request from ${requests[index].username}"),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.orange,
                    minimumSize: Size.fromRadius(10),
                    padding: EdgeInsets.all(8),
                    shape: CircleBorder(),
                  ),
                ),
                OutlinedButton(
                  child: Icon(Icons.clear),
                  onPressed: () => print("rejected connection request from ${requests[index].username}"),
                  style: OutlinedButton.styleFrom(
                    primary: Colors.orange,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.orange),
                    minimumSize: Size.fromRadius(10),
                    padding: EdgeInsets.all(8),
                    shape: CircleBorder(),
                  ),
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