import 'dart:io';
import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import '../models/myModel.dart';
import '../models/notifierValue.dart';
import '../util/mycss.dart';
import 'common/myAlertDialog.dart';
import 'common/myTextInput.dart';

class MyAppBar extends StatefulWidget {
  MyAppBar({Key? key, required this.drawer}) : super(key: key);

  final drawer;

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  final _searchController = new TextEditingController();
  bool _visible = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _search() {
    return Row(
      children: [
        Visibility(
            child: MyTextInput(
              control: _searchController,
              label: "",
              hintLabel: S.current.pleaseInput + S.current.info,
              hideText: false,
              icon: Icons.search,
              press: () {
                if (_searchController.text != "") {
                  activeID.value = _searchController.text;
                  if (mounted) {
                    setState(() {
                      _visible = false;
                    });
                  }
                  indexValue.value = 10;
                } else {
                  showMyAlertDialog(
                      context, S.current.notive, S.current.noContent);
                }
                //  _getSongsbyName();
              },
              titleStyle: titleText1,
              mainaxis: MainAxisAlignment.start,
              crossaxis: CrossAxisAlignment.end,
            ),
            visible: _visible),
        Container(
            child: ValueListenableBuilder<ServerInfo>(
                valueListenable: serversInfo,
                builder: ((context, _value, child) {
                  return IconButton(
                    icon: Icon(
                      Icons.search,
                      color: _value.baseurl.isNotEmpty ? textGray : badgeDark,
                      size: 15,
                    ),
                    onPressed: _value.baseurl.isNotEmpty
                        ? () async {
                            // indexValue.value = 10;
                            setState(() {
                              if (_visible) {
                                _visible = false;
                              } else {
                                _visible = true;
                              }
                            });
                          }
                        : null,
                  );
                }))),
        Container(
          child: IconButton(
            icon: Icon(
              Icons.settings,
              color: textGray,
              size: 15,
            ),
            onPressed: () {
              indexValue.value = 11;
            },
          ),
        ),
      ],
    );
  }

  Widget _menu() {
    return Row(
      children: [
        if (isMobile)
          IconButton(
            icon: Icon(
              Icons.menu,
              color: textGray,
              size: 15,
            ),
            color: textGray,
            onPressed: () {
              widget.drawer();
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: appBarHeight,
      color: bkColor,
      child: Platform.isWindows
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_search(), _menu()],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_menu(), _search()],
            ),
    );
  }
}
