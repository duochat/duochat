import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duochat/models.dart';
import 'package:duochat/widget/top_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  static String id = 'edit_profile';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController;
  TextEditingController bioController;
  TextEditingController interestsController;

  @override
  void initState() {
    super.initState();
    nameController = new TextEditingController(text: "Loading...");
    bioController = new TextEditingController(text: "Loading...");
    interestsController = new TextEditingController(text: "Loading...");

    FirebaseFirestore.instance
        .collection('publicUserInfo')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((snap) {
      PublicUserData data = PublicUserData.fromMap(snap.data());
      nameController.text = data.name;
      bioController.text = data.bio;
      interestsController.text = data.interests;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopNavBar(
              title: "Edit Profile",
              suffix: CupertinoButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    FirebaseFirestore.instance
                        .collection('publicUserInfo')
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .update({
                      "name": nameController.text,
                      "bio": bioController.text,
                      "interests": interestsController.text,
                    }).then((value) {
                      Navigator.pop(context);
                    });
                  }
                },
                child: Row(
                  children: <Widget>[
                    Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        labelText: 'Name',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This field is required.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: bioController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        labelText: 'Bio',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This field is required.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: interestsController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        labelText: 'Career Interests',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Adding career interests improves connection results!';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
