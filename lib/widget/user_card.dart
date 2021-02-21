import 'package:duochat/models.dart';
import 'package:flutter/material.dart';

class SlideIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration reverseDuration;
  final Duration delay;

  SlideIn({
    Key key,
    this.child = const SizedBox(width: 0, height: 0),
    this.duration = const Duration(milliseconds: 500),
    this.reverseDuration,
    this.delay = Duration.zero,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SlideInState(
        child: child,
        duration: duration,
        reverseDuration: reverseDuration,
        delay: delay,
      );
}

class SlideInState extends State<SlideIn> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> _appearAnimation;
  bool isVisible = false;

  final Widget child;
  final Duration duration;
  final Duration reverseDuration;
  final Duration delay;

  SlideInState({
    this.child,
    this.duration,
    this.reverseDuration,
    this.delay,
  });

  void slideIn() {
    Future.delayed(delay, () {
      _animationController.forward();
      setState(() { isVisible = true; });
    });
  }

  void slideOut() {
    setState(() { isVisible = false; });
    Future.delayed(delay, () {
      _animationController.reverse();
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: duration,
      reverseDuration: reverseDuration,
      vsync: this,
    );
    _appearAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    Future.delayed(delay, () {
      _animationController.forward();
      setState(() { isVisible = true; });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(),
      child: SlideTransition(
        position: _appearAnimation,
        child: AnimatedOpacity(
          opacity: isVisible ? 1 : 0,
          duration: duration,
          child: child,
        ),
      ),
    );
  }
}

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
        margin: EdgeInsets.only(right: 20.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        decoration: BoxDecoration(
//          gradient: LinearGradient(
//            colors: [const Color(0xFFFFE0B0), const Color(0xFFFFF0D0)],
//          ),

        // border: Border(
        //   top: BorderSide(color: Theme.of(context).primaryColor),
        //   bottom: BorderSide(color: Theme.of(context).primaryColor),
        // ),
          // borderRadius: BorderRadius.horizontal(
          //   right: Radius.circular(25.0),
          // ),
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
                  )
                : SizedBox(width: 0),
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
                        )
                      : SizedBox(height: 0),
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
