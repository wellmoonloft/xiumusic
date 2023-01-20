import 'package:flutter/material.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';

class MyAppBar extends StatefulWidget {
  MyAppBar({Key? key, required this.drawer}) : super(key: key);

  final drawer;

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _search() {
    return Row(
      children: [
        Container(
          child: IconButton(
            icon: Icon(
              Icons.search,
              color: textGray,
              size: 15,
            ),
            onPressed: () async {
              indexValue.value = 10;
            },
          ),
        ),
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
      child: isWindows
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
