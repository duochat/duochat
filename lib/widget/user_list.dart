import 'package:duochat/models.dart';
import 'package:flutter/material.dart';
import 'user_card.dart';
import 'package:duochat/screens/profile_screen.dart';

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
            onTap: () => Navigator.pushNamed(
              context,
              ProfileScreen.id,
              arguments: ProfileScreenArguments(requests[index]),
            ),
            contextWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: Icon(Icons.check),
                  onPressed: () => print("accepted connection request from ${requests[index].username}"),
                  style: TextButton.styleFrom(
                    minimumSize: Size.fromRadius(10),
                    shape: CircleBorder(),
                  ),
                ),
                OutlinedButton(
                  child: Icon(Icons.clear),
                  onPressed: () => print("rejected connection request from ${requests[index].username}"),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromRadius(10),
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
            onTap: () => Navigator.pushNamed(
              context,
              ProfileScreen.id,
              arguments: ProfileScreenArguments(results[index]),
            ),
          );
        },
      ),
    );
  }
  
}