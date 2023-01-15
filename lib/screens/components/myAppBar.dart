import 'package:flutter/material.dart';
import '../../models/notifierValue.dart';
import '../common/baseCSS.dart';
import 'customSearchDelegate.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: appBarHeight,
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
                  onPressed: () async {
                    //indexValue.value = 10;
                    //TODO 快捷搜索
                    showSearch(
                        context: context, delegate: CustomSearchDelegate());
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
                    indexValue.value = 11;
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
