import 'dart:async';
import 'package:flutter/material.dart';
import 'baseCSS.dart';

class MyToast {
  static void show({required BuildContext context, required String message}) {
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return Positioned(
          bottom: 95,
          child: Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  message,
                  style: nomalGrayText,
                ),
              ),
              color: badgeDark,
            ),
          ));
    });

    Overlay.of(context)?.insert(overlayEntry);
    Future.delayed(Duration(seconds: 1)).then((value) {
      overlayEntry.remove();
    });
  }
}
