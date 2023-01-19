import 'package:flutter/material.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);

  final String title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        child: Text(title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                decoration: TextDecoration.underline, color: textGray)),
      ),
    );
  }
}

class MyTextIconButton extends StatelessWidget {
  const MyTextIconButton({
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
