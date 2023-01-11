import 'package:flutter/material.dart';

import 'baseCSS.dart';

class MyTextInput extends StatelessWidget {
  const MyTextInput({
    Key? key,
    required this.control,
    required this.label,
    required this.hintLabel,
    required this.hideText,
    required this.icon,
  }) : super(key: key);

  final control;
  final bool hideText;
  final String label;
  final String hintLabel;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: nomalGrayText,
        ),
        Container(
          width: 220,
          height: 35,
          margin: EdgeInsets.all(5),
          child: TextField(
              controller: control,
              decoration: InputDecoration(
                  hintText: hintLabel,
                  labelStyle: nomalGrayText,
                  border: InputBorder.none,
                  hintStyle: nomalGrayText,
                  filled: true,
                  fillColor: badgeDark,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  prefixIcon: Icon(
                    icon,
                    color: kGrayColor,
                    size: 14,
                  )),
              style: nomalGrayText,
              obscureText: hideText,
              cursorColor: kGrayColor),
        )
      ],
    );
  }
}
