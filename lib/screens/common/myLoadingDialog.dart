import 'package:flutter/material.dart';
import 'baseCSS.dart';

showMyLoadingDialog(BuildContext _context, String _title) {
  showDialog(
    barrierDismissible: false,
    context: _context,
    builder: (_context) {
      return Dialog(
          backgroundColor: Colors.transparent,
          child: UnconstrainedBox(
              child: Container(
            width: _title.length * 20,
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: badgeDark,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: kGrayColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    _title,
                    style: nomalGrayText,
                  )
                ],
              ),
            ),
          )));
    },
  );
}
