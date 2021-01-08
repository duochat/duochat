import 'package:flutter/material.dart';

import '../constants.dart';

class Loading extends StatelessWidget {
  const Loading();

  @override
  Widget build(BuildContext context) {
    return Container(
	    decoration: BoxDecoration(color: Color.fromARGB(100, 255, 255, 255)),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
        ),
      ),
      color: Colors.black.withOpacity(0.8),
    );
  }
}
