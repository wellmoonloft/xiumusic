import 'dart:io';
import 'package:flutter/material.dart';
import '../models/notifierValue.dart';
import '../util/baseCSS.dart';
import 'components/roter.dart';
import 'layout/settings.dart';
import 'left_screen.dart';

class RightScreen extends StatefulWidget {
  const RightScreen({Key? key}) : super(key: key);

  @override
  _RightScreenState createState() => _RightScreenState();
}

class _RightScreenState extends State<RightScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool _isMobile = true;
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      _isMobile = false;
    }
    return Scaffold(
        key: _scaffoldKey,
        drawer: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 160),
          child: LeftScreen(),
        ),
        body: Container(
          color: rightColor,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (_isMobile)
                        IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: kTextColor,
                            size: 15,
                          ),
                          color: kTextColor,
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                      if (_isMobile) SizedBox(width: 5),
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
              ValueListenableBuilder<bool>(
                  valueListenable: isServers,
                  builder: ((context, _value, child) {
                    return Container(
                      child: _value
                          ? ValueListenableBuilder<int>(
                              valueListenable: indexValue,
                              builder: ((context, value, child) {
                                return Roter(roter: value);
                              }))
                          : Settings(),
                    );
                  }))
            ],
          ),
        ));
  }
}
