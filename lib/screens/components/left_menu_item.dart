import 'package:flutter/material.dart';

import '../../util/baseCSS.dart';

class LeftMenuItem extends StatelessWidget {
  const LeftMenuItem({
    Key key,
    this.isActive,
    @required this.title,
    @required this.icon,
    @required this.press,
  }) : super(key: key);

  final bool isActive;
  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: InkWell(
        onTap: press,
        child: Row(
          children: [
            SizedBox(width: kDefaultPadding / 4),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 10, right: 5),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      size: 15,
                      color: (isActive) ? kTextColor : kGrayColor,
                    ),
                    SizedBox(width: kDefaultPadding * 0.75),
                    Text(title,
                        style: TextStyle(
                            color: (isActive) ? kTextColor : kGrayColor,
                            fontWeight: (isActive)
                                ? FontWeight.w400
                                : FontWeight.w100)),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
