import 'package:duochat/widget/top_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  static String id = 'support_screen';

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopNavBar(
              title: "Support",
              suffix: CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: <Widget>[
                    Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
              child: Text(
                "We're sorry to hear that you're facing issues. Report the issue below and we'll fix it as soon as possible!",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  expands: true,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Compose your message here...",
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 20.0,
              ),
              width: double.infinity,
              child: CupertinoButton(
                child: Text('Send'),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  handleSubmit();
                },
                borderRadius: BorderRadius.all(Radius.circular(1000.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleSubmit() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Thanks for your feedback!'),
          content: SingleChildScrollView(
            child: Text('Our team will fix this issue as soon as possible.'),
          ),
          actions: <Widget>[
            CupertinoButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
