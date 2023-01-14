import 'package:flutter/material.dart';
import '../../util/localizations.dart';
import '../common/baseCSS.dart';
import '../common/myStructure.dart';
import '../common/textButtom.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  initState() {
    super.initState();
  }

  Widget _buildTopWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(child: Text(favoriteLocal, style: titleText1)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              " 111",
              style: nomalGrayText,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "222 ",
              style: nomalGrayText,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "333 ",
              style: nomalGrayText,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: 1,
            child: Container(
              child: Text(
                nameLocal,
                textDirection: TextDirection.ltr,
                style: sublGrayText,
              ),
            )),
        Expanded(
          flex: 1,
          child: Text(
            albumLocal,
            textDirection: TextDirection.rtl,
            style: sublGrayText,
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
              child: Text(
            songLocal,
            textDirection: TextDirection.rtl,
            style: sublGrayText,
          )),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
        top: 120,
        headerWidget: Column(
          children: [
            _buildTopWidget(),
            SizedBox(
              height: 24,
            ),
          ],
        ),
        contentWidget: Container());
  }
}
