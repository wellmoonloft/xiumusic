import 'package:flutter/material.dart';

import '../common/baseCSS.dart';

class SearchAppBar extends StatefulWidget {
  SearchAppBar({Key? key, required this.hintLabel}) : super(key: key);

  final String hintLabel;

  @override
  State<StatefulWidget> createState() {
    return SearchAppBarState();
  }
}

class SearchAppBarState extends State<SearchAppBar> {
  late FocusNode _focusNode;

  ///默认不展示控件

  bool _offstage = true;

  ///监听TextField内容变化
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _textEditingController.addListener(() {
      var isVisible = _textEditingController.text.isNotEmpty;
      _updateDelIconVisible(isVisible);
    });
  }

  _updateDelIconVisible(bool isVisible) {
    setState(() {
      _offstage = !isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 30,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              margin: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                  color: borderColor, borderRadius: BorderRadius.circular(4)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // paddingOnly(const EdgeInsets.only(left: 8)),
                  Icon(
                    Icons.search,
                    color: kGrayColor,
                    size: 15,
                  ),
                  //paddingOnly(const EdgeInsets.only(left: 8)),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: _textEditingController,
                      autofocus: true,
                      focusNode: _focusNode,
                      style: nomalText1,
                      //decoration: boxInputDecoration(widget.hintLabel),
                      maxLines: 1,
                    ),
                  ),
                  //paddingOnly(const EdgeInsets.only(right: 8)),
                  Offstage(
                      offstage: _offstage,
                      child: IconButton(
                        icon: Icon(
                          Icons.search_off,
                          color: kGrayColor,
                          size: 15,
                        ),
                        onPressed: () {
                          _textEditingController.clear();
                        },
                      )),
                  //paddingOnly(const EdgeInsets.only(right: 8)),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _focusNode.unfocus();
            },
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text("取消",
                  style: TextStyle(fontSize: 16, color: Color(0xFF3D7DFF))),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.unfocus();
  }
}
