import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../generated/l10n.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import 'myTextButton.dart';

class MyStructure extends StatelessWidget {
  const MyStructure({
    Key? key,
    required this.headerWidget,
    required this.contentWidget,
    required this.top,
  }) : super(key: key);

  final Widget headerWidget;
  final Widget contentWidget;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
          height: top,
          color: bkColor,
          child: headerWidget,
          padding: leftrightPadding,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
            height: (isMobile)
                ? windowsHeight.value - (top + bottomHeight + 50 + safeheight)
                : windowsHeight.value - (top + bottomHeight + 50),
            color: rightColor,
            child: contentWidget)
      ],
    ));
  }
}

List<Widget> mylistView(List<String> _title, TextStyle _style) {
  List<Widget> _list = [];
  for (var i = 0; i < _title.length; i++) {
    _list.add(Expanded(
      flex: (i == 0) ? 2 : 1,
      child: Text(
        _title[i],
        textDirection: (i == 0) ? TextDirection.ltr : TextDirection.rtl,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: _style,
      ),
    ));
  }
  return _list;
}

Widget myRowList(List<String> _title, TextStyle _style) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: mylistView(_title, _style));
}

showShareDialog(Sharelist _tem, BuildContext _context) {
  showDialog(
    barrierDismissible: false,
    context: _context,
    builder: (context) {
      return AlertDialog(
        titlePadding: EdgeInsets.all(10),
        contentPadding: EdgeInsets.all(10),
        titleTextStyle: nomalText,
        contentTextStyle: nomalText,
        backgroundColor: badgeDark,
        title: Text(
          _tem.description,
        ),
        content: Text(
          _tem.username,
        ),
        actions: <Widget>[
          MyTextButton(
            title: S.current.cancel,
            press: () {
              Navigator.of(context).pop(0);
            },
          ),
          MyTextButton(
            title: S.current.share + S.current.to,
            press: () {
              Share.share(_tem.url,
                  subject: _tem.username + S.current.share + _tem.description);
              Navigator.of(context).pop(1);
            },
          )
        ],
      );
    },
  );
}
