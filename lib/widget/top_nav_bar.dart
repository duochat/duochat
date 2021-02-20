import 'package:flutter/material.dart';

class TopNavBar extends StatelessWidget {
  final ImageProvider<dynamic> image;
  final String title;
  final Widget suffix;
  final bool hasImageBorder;

  const TopNavBar({
    Key key,
    this.image,
    this.title,
    this.suffix,
    this.hasImageBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: <Widget>[
          image == null ? SizedBox(width: 0) :
          hasImageBorder ? Container(
            child: CircleAvatar(
              backgroundImage: image,
            ),
            width: 50.0,
            height: 50.0,
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
          ) :
          Image(
            image: image,
            width: 50.0,
            height: 50.0,
          ),
          SizedBox(width: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                title,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          suffix,
        ],
      ),
    );
  }
}

class TopSearchBar extends StatelessWidget {

  final String hint;
  final Widget suffix;
  final Function(String value) onChanged;
  final FocusNode focusNode;

  const TopSearchBar({
    Key key,
    this.hint,
    this.suffix,
    this.onChanged,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      height: 60,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              focusNode: focusNode,
              autofocus: true,
              autocorrect: false,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                ),
                hintText: hint,
              ),
              onChanged: onChanged,
            ),
          ),
          SizedBox(width: 10),
          suffix,
        ],
      ),
    );
  }

}