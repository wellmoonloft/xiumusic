import 'dart:math';

import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  //buildActions输入框后面的控件，一般情况下，输入框不为空，显示一个清空按钮，点击清空输入框：
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
        ),
        onPressed: () {
          close(context, '');
        },
      )
    ];
  }

//buildLeading表示构建搜索框前面的控件，一般是一个返回按钮，点击退出，代码如下：
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.blue,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

//buildResults是构建搜索结果控件，当用户点击软键盘上的“Search”时回调此方法，一般返回ListView，用法如下：
  @override
  Widget buildResults(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Container(
          height: 60,
          alignment: Alignment.center,
          child: Text(
            '$index',
            style: TextStyle(fontSize: 20),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: 10,
    );
  }

//buildSuggestions是用户正在输入时显示的控件，输入框放生变化时回调此方法，通常返回一个ListView，点击其中一项时，将当前项的内容填充到输入框
  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('老孟 $index'),
          onTap: () {
            query = '老孟 $index';
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: Random().nextInt(5),
    );
  }
}
