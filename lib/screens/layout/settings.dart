import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/basecss.dart';
import '../../util/httpclient.dart';

import '../../util/util.dart';
import '../components/text_buttom.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isSave = false;
  final servercontroller = new TextEditingController();
  final usernamecontroller = new TextEditingController();
  final passwordcontroller = new TextEditingController();

  String md5RandomString(String _password) {
    final randomNumber = Random().toString();
    final randomBytes = utf8.encode(randomNumber + _password);
    final randomString = md5.convert(randomBytes).toString();
    return randomString;
  }

  saveString() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (servercontroller.text != "" &&
        usernamecontroller.text != "" &&
        passwordcontroller.text != "") {
      print(servercontroller.text);
      var status = await testServer(servercontroller.text,
          usernamecontroller.text, passwordcontroller.text);

      if (status) {
        sharedPreferences.setString(
            "baseurl", servercontroller.text.toString());
        sharedPreferences.setString(
            "username", usernamecontroller.text.toString());
        sharedPreferences.setString(
            "password", passwordcontroller.text.toString());
        final randomNumber = generateRandomString();
        final randomBytes =
            utf8.encode(passwordcontroller.text.toString() + randomNumber);
        final randomString = md5.convert(randomBytes).toString();
        sharedPreferences.setString("salt", randomNumber);
        sharedPreferences.setString("hash", randomString);
        sharedPreferences.setBool("isSave", true);
        setState(() {
          _isSave = true;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("服务器错误"),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('确定'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      print(servercontroller.text);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("填写内容"),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  getServerStats() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if (sharedPreferences.getBool("isSave") != null) {
        _isSave = sharedPreferences.getBool("isSave") ?? false;

        servercontroller.text = sharedPreferences.getString("baseurl")!;
        usernamecontroller.text = sharedPreferences.getString("username")!;
        passwordcontroller.text = sharedPreferences.getString("password")!;
      }
    });
  }

  deleteServer() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _isSave = false;
      sharedPreferences.remove("isSave");
      sharedPreferences.remove("baseurl");
      sharedPreferences.remove("username");
      sharedPreferences.remove("password");
      sharedPreferences.remove("hash");
      sharedPreferences.remove("hash");
      servercontroller.text = "";
      usernamecontroller.text = "";
      passwordcontroller.text = "";
    });
  }

  @override
  initState() {
    super.initState();
    getServerStats();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        //height: 300,
        padding: const EdgeInsets.all(20),
        //color: Colors.blue,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("配置", style: titleText1),
                Container(
                    //padding: EdgeInsets.all(5),
                    decoration: new BoxDecoration(
                      color: rightColor,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      //设置四周边框
                      //border: new Border.all(width: 1, color: Colors.red),
                    ),
                    child: TextButtom(
                      press: () {
                        getGenres();
                      },
                      title: "占位",
                      isActive: false,
                    ))
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButtom(
                      press: () {},
                      title: "回放",
                      isActive: false,
                    ),
                    TextButtom(
                      press: () {},
                      title: "外观和风格",
                      isActive: false,
                    ),
                    TextButtom(
                      press: () {},
                      title: "其他",
                      isActive: true,
                    )
                  ],
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButtom(
                      press: () {},
                      title: "扫描",
                      isActive: false,
                    ),
                    TextButtom(
                      press: () {},
                      title: "恢复默认",
                      isActive: false,
                    ),
                    TextButtom(
                      press: () {},
                      title: "版本",
                      isActive: false,
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Container(
                padding: EdgeInsets.all(10),
                decoration: circularBorder,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "服务器",
                          style: titleText2,
                        ),
                        TextButtom(
                          press: () {
                            _isSave ? deleteServer() : saveString();
                          },
                          title: _isSave ? "断开连接" : "保存",
                          isActive: false,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "服务器地址",
                          style: nomalText,
                        ),
                        Container(
                          width: 200,
                          height: 40,
                          child: TextField(
                              controller: servercontroller,
                              decoration: InputDecoration(
                                  hintText: "请输入服务器地址",
                                  labelStyle: subText,
                                  // fillColor: Color.fromARGB(255, 98, 98, 98),
                                  // filled: true,
                                  border: InputBorder.none,
                                  hintStyle: subText),
                              style: nomalText,
                              cursorColor: Colors.white),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "用户名",
                          style: nomalText,
                        ),
                        Container(
                          width: 200,
                          height: 40,
                          child: TextField(
                              controller: usernamecontroller,
                              decoration: InputDecoration(
                                  hintText: "请输入用户名",
                                  labelStyle: subText,
                                  border: InputBorder.none,
                                  hintStyle: subText),
                              style: nomalText,
                              cursorColor: Colors.white),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "密码",
                          style: nomalText,
                        ),
                        Container(
                          width: 200,
                          height: 40,
                          child: TextField(
                              controller: passwordcontroller,
                              decoration: InputDecoration(
                                  hintText: "请输入密码",
                                  labelStyle: subText,
                                  border: InputBorder.none,
                                  hintStyle: subText),
                              style: nomalText,
                              obscureText: true,
                              cursorColor: Colors.white),
                        )
                      ],
                    )
                  ],
                ))
          ],
        ));
  }
}
