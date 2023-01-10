import 'package:flutter/material.dart';
import '../../models/notifierValue.dart';
import 'baseCSS.dart';

class TextButtom extends StatelessWidget {
  const TextButtom({
    Key? key,
    required this.isActive,
    required this.title,
    required this.press,
  }) : super(key: key);

  final bool isActive;
  final String title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        //padding: EdgeInsets.only(right: 15),
        child: Text(title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: (isActive) ? kTextColor : kGrayColor,
                fontWeight: (isActive) ? FontWeight.w400 : FontWeight.w100)),
      ),
    );
  }
}

class TextIconButtom extends StatelessWidget {
  const TextIconButtom({
    Key? key,
    required this.title,
    required this.icon,
    required this.press,
    required this.color,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback press;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isServers,
        builder: ((context, _value, child) {
          return InkWell(
            onTap: _value ? press : null,
            child: Container(
              padding: updownPadding,
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 15,
                    color: color,
                  ),
                  SizedBox(width: 15),
                  Text(title, style: TextStyle(color: color)),
                  Spacer(),
                ],
              ),
            ),
          );
        }));
  }
}
