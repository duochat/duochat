import 'package:duochat/db.dart';
import 'package:duochat/models.dart';
import 'package:duochat/widget/top_nav_bar.dart';
import 'package:duochat/widget/user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:duochat/screens/profile_screen.dart';

class RequestsScreenArguments {
  final List<PublicUserData> requests;
  final Function onRefresh;

  RequestsScreenArguments({this.requests, this.onRefresh});
}

class IncomingRequestsScreen extends StatefulWidget {
  static String id = 'incoming_requests_screen';
  @override
  State<StatefulWidget> createState() => _IncomingRequestsScreenState();
}
class _IncomingRequestsScreenState extends State<IncomingRequestsScreen> {

  List<PublicUserData> requests = [];
  Function onRefresh;

  @override
  Widget build(BuildContext context) {
    final RequestsScreenArguments args = ModalRoute.of(context).settings.arguments;
    requests = args.requests;
    onRefresh = args.onRefresh;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              TopNavBar(
                title: 'Incoming Requests',
                suffix: CupertinoButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.arrow_back,
                        size: 18.0,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: onRefresh,
                  child: ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (BuildContext context, int index) {
                      return UserCard(
                        user: requests[index],
                        message: requests[index].username,
                        onTap: () => Navigator.pushNamed(
                          context,
                          ProfileScreen.id,
                          arguments: ProfileScreenArguments(
                            user: requests[index],
                            onRefresh: onRefresh,
                          ),
                        ),
                        contextWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              child: Icon(Icons.check),
                              onPressed: () async {
                                print("accepted connection request from ${requests[index].username}");
                                DatabaseService.acceptRequest(context, requests[index].id);
                                onRefresh();
                              },
                              style: TextButton.styleFrom(
                                minimumSize: Size.fromRadius(10),
                                shape: CircleBorder(),
                              ),
                            ),
                            OutlinedButton(
                              child: Icon(Icons.clear),
                              onPressed: () {
                                print("rejected connection request from ${requests[index].username}");
                                DatabaseService.rejectRequest(context, requests[index].id);
                                onRefresh();
                              },
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class OutgoingRequestsScreen extends StatefulWidget {
  static String id = 'outgoing_requests_screen';
  @override
  State<StatefulWidget> createState() => _OutgoingRequestsScreenState();
}
class _OutgoingRequestsScreenState extends State<OutgoingRequestsScreen> {
// class OutgoingRequestsScreen extends StatelessWidget {
  // static String id = 'outgoing_requests_screen';
  //
  // final List<PublicUserData> requests;
  // final Function onRefresh;
  //
  // const OutgoingRequestsScreen({
  //   Key key,
  //   this.requests,
  //   this.onRefresh
  // }) : super(key: key);


  List<PublicUserData> requests;
  Function onRefresh;

  @override
  Widget build(BuildContext context) {
    final RequestsScreenArguments args = ModalRoute.of(context).settings.arguments;
    requests = args.requests;
    onRefresh = args.onRefresh;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              TopNavBar(
                title: 'Outgoing Requests',
                suffix: CupertinoButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.arrow_back,
                        size: 18.0,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: onRefresh,
                  child: ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (BuildContext context, int index) {
                      return UserCard(
                        user: requests[index],
                        message: requests[index].username,
                        onTap: () =>
                            Navigator.pushNamed(
                              context,
                              ProfileScreen.id,
                              arguments: ProfileScreenArguments(
                                user: requests[index],
                                onRefresh: onRefresh,
                              ),
                            ),
                        contextWidget: OutlinedButton(
                          child: Icon(Icons.clear),
                          onPressed: () {
                            DatabaseService.cancelRequest(context, requests[index].id);
                            onRefresh();
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size.fromRadius(10),
                            shape: CircleBorder(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}