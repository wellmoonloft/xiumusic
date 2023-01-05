import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xiumusic/responsive.dart';

import '../util/basecss.dart';
import '../util/userprovider.dart';
import 'components/roter.dart';
import 'layout/settings.dart';
import 'left_screen.dart';

class RightScreen extends StatefulWidget {
  // Press "Command + ."
  const RightScreen({Key? key}) : super(key: key);

  @override
  _RightScreenState createState() => _RightScreenState();
}

class _RightScreenState extends State<RightScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSave = false;

  @override
  initState() {
    super.initState();
    deleteServer();
  }

  deleteServer() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if (sharedPreferences.getBool("isSave") != null) {
        _isSave = sharedPreferences.getBool("isSave") ?? false;
      }
    });
  }

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
                          color: kTextColor,
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
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
                            _scaffoldKey.currentState?.openDrawer();
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
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                child: _isSave
                    ? Roter(
                        roter: Provider.of<UserProvider>(context).index,
                      )
                    : Settings(),
              )
            ],
          ),
        ));
  }
}
