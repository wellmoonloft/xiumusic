import 'package:flutter/material.dart';
import '../common/baseCSS.dart';

class MyStatefulButtom extends StatefulWidget {
  const MyStatefulButtom({Key? key}) : super(key: key);
  @override
  _MyStatefulButtomState createState() => _MyStatefulButtomState();
}

class _MyStatefulButtomState extends State<MyStatefulButtom> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.playlist_add,
        color: kTextColor,
        size: 16,
      ),
      onPressed: () {
        final RenderBox? button = context.findRenderObject() as RenderBox?;
        Offset offset = button!.localToGlobal(Offset.zero);
        final RenderBox? overlay =
            Overlay.of(context)?.context.findRenderObject() as RenderBox?;
        final RelativeRect position = RelativeRect.fromRect(
          Rect.fromPoints(
            button.localToGlobal(Offset(0, -200), ancestor: overlay),
            button.localToGlobal(button.size.bottomRight(Offset.zero),
                ancestor: overlay),
          ),
          Offset.zero & overlay!.size,
        );
        print(offset);
        print(position);
        showMenu(context: context, position: position, items: <PopupMenuEntry>[
          PopupMenuItem(child: Text('语文')),
          PopupMenuDivider(),
          CheckedPopupMenuItem(
            child: Text('数学'),
            checked: true,
          ),
          PopupMenuDivider(),
          PopupMenuItem(child: Text('英语')),
        ]);
      },
    );
  }
}
