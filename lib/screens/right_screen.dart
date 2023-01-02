import 'package:flutter/material.dart';
import 'package:xiumusic/responsive.dart';

import '../util/baseCSS.dart';
import 'left_screen.dart';

class RightScreen extends StatefulWidget {
  // Press "Command + ."
  const RightScreen({
    Key key,
  }) : super(key: key);

  @override
  _RightScreenState createState() => _RightScreenState();
}

class _RightScreenState extends State<RightScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 220),
          child: LeftScreen(),
        ),
        body: Container(
          color: rightColor,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Once user click the menu icon the menu shows like drawer
                  // Also we want to hide this menu icon on desktop
                  Row(
                    children: [
                      if (!Responsive.isDesktop(context))
                        IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            _scaffoldKey.currentState.openDrawer();
                          },
                        ),
                      if (!Responsive.isDesktop(context)) SizedBox(width: 5),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: kTextColor,
                            size: 15,
                          ),
                          onPressed: () {
                            _scaffoldKey.currentState.openDrawer();
                          },
                        ),
                      ),
                      Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.settings,
                            color: kTextColor,
                            size: 15,
                          ),
                          onPressed: () {
                            _scaffoldKey.currentState.openDrawer();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                //height: 500,
                //width: 500,
                color: bkColor,
                child: Text("sss"),
              )
            ],
          ),
        ));
  }
}
