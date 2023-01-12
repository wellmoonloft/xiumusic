import 'package:flutter/material.dart';
import '../../models/notifierValue.dart';
import '../common/baseCSS.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  MyAppBar({Key? key, required this.drawer}) : super(key: key);

  final drawer;

  @override
  _AMyAppBarState createState() => _AMyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}

class _AMyAppBarState extends State<MyAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bkColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (isMobile.value)
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: kGrayColor,
                    size: 15,
                  ),
                  color: kGrayColor,
                  onPressed: () {
                    widget.drawer();
                  },
                ),
            ],
          ),
          Row(
            children: [
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: kGrayColor,
                    size: 15,
                  ),
                  onPressed: () {
                    indexValue.value = 10;
                  },
                ),
              ),
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: kGrayColor,
                    size: 15,
                  ),
                  onPressed: () {
                    indexValue.value = 7;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
