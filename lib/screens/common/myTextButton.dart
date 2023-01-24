import 'package:flutter/material.dart';
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
                decoration: TextDecoration.underline,
                color: textGray,
                fontSize: 14)),
      ),
    );
  }
}
