import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/baseCSS.dart';
import '../../models/baseDB.dart';
import '../../util/httpClient.dart';
import '../../util/util.dart';
import '../components/dialog.dart';
import '../components/text_buttom.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  //bool _isServer1 = false;
  final servercontroller = new TextEditingController();
  final usernamecontroller = new TextEditingController();
  final passwordcontroller = new TextEditingController();

  String md5RandomString(String _password) {
    final randomNumber = Random().toString();
    final randomBytes = utf8.encode(randomNumber + _password);
    final randomString = md5.convert(randomBytes).toString();
    return randomString;
  }

  _saveServer() async {
    if (servercontroller.text != "" &&
        usernamecontroller.text != "" &&
        passwordcontroller.text != "") {
      //print(servercontroller.text);
      var status = await testServer(servercontroller.text,
          usernamecontroller.text, passwordcontroller.text);

      if (status) {
        final _randomNumber = generateRandomString();
        final _randomBytes =
            utf8.encode(passwordcontroller.text.toString() + _randomNumber);
        final _randomString = md5.convert(_randomBytes).toString();

        ServerInfo _serverInfo = ServerInfo(
            baseurl: servercontroller.text.toString(),
            username: usernamecontroller.text.toString(),
            password: passwordcontroller.text.toString(),
            salt: _randomNumber,
            hash: _randomString);
        await BaseDB.instance.addServerInfo(_serverInfo);
        setState(() {
          isServers.value = true;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return MyAlertDialog("提示", "服务器错误");
          },
        );
      }
    } else {
      print(servercontroller.text);
      showDialog(
        context: context,
        builder: (context) {
          return MyAlertDialog("提示", "填写内容");
        },
      );
    }
  }

  _getServerInfo() async {
    final _infoList = await BaseDB.instance.getServerInfo();
    // ignore: unnecessary_null_comparison
    if (_infoList != null) {
      //ServerInfo _serverInfo = _infoList;
      setState(() {
        isServers.value = true;
        servercontroller.text = _infoList.baseurl;
        usernamecontroller.text = _infoList.username;
        passwordcontroller.text = _infoList.password;
      });
    }
  }

  _deleteServer() async {
    await BaseDB.instance.deleteServerInfo(usernamecontroller.text);
    setState(() {
      isServers.value = false;
      servercontroller.text = "";
      usernamecontroller.text = "";
      passwordcontroller.text = "";
    });
  }

  @override
  initState() {
    super.initState();
    _getServerInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
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
                        ValueListenableBuilder<bool>(
                            valueListenable: isServers,
                            builder: ((context, _value, child) {
                              return TextButtom(
                                press: () {
                                  _value ? _deleteServer() : _saveServer();
                                },
                                title: _value ? "断开连接" : "保存",
                                isActive: false,
                              );
                            }))
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
