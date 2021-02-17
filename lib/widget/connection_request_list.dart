import 'package:duochat/models.dart';
import 'package:flutter/material.dart';
import 'user_card.dart';

class ConnectionRequestList extends StatelessWidget {

  List<UserData> requests = [
    UserData(name: 'Kitty', id: '1', photoURL: 'https://i.imgur.com/O9z1hcx.png', username: 'ghost_cat'),
    UserData(name: 'Cat with a name so long the card expands (should this be legal?) also you can\'t see the username anymore lol', id: '2', photoURL: 'https://i.imgur.com/UYcL5sl.jpg', username: 'paint_cat_with_a_really_super_long_username'),
    UserData(name: 'Random Girl', id: '5', photoURL: 'https://i.imgur.com/6xFjIVa.jpg', username: 'commonapp_girl'),
  ];



  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (BuildContext context, int index) {
          final UserData chat = requests[index];
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