import 'package:flutter/material.dart';
import '../../util/basecss.dart';

class TextIconButtom extends StatelessWidget {
  const TextIconButtom({
    Key? key,
    required this.title,
    required this.icon,
    required this.press,
    required this.color,
    required this.weight,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback press;
  final Color color;
  final FontWeight weight;

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
                      color: color,
                    ),
                    SizedBox(width: kDefaultPadding * 0.75),
                    Text(title,
                        style: TextStyle(color: color, fontWeight: weight)),
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
