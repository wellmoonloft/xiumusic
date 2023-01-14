import 'package:flutter/material.dart';

import 'baseCSS.dart';

class ToastWidget extends StatelessWidget {
  ToastWidget({Key? key, required this.msg}) : super(key: key);

  ///toast msg
  final String msg;

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      constrainedAxis: Axis.vertical,
      child: SizedBox(
          // margin: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          // padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),

          width: 100,
          child: Dialog(
            child: Container(
              color: badgeDark,
              height: 100,
              child: Text('$msg', style: TextStyle(color: Colors.white)),
            ),
          )),
    );
  }
}
