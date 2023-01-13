import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../common/baseCSS.dart';
import '../../util/baseDB.dart';
import '../../util/handling.dart';
import '../../util/httpClient.dart';
import '../../util/localizations.dart';
import '../../util/util.dart';
import '../common/myDialog.dart';
import '../common/myTextInput.dart';
import '../common/rightHeader.dart';
import '../common/textButtom.dart';

class Settings extends StatefulWidget {
  const Settings({
    Key? key,
  }) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final servercontroller = new TextEditingController();
  final usernamecontroller = new TextEditingController();
  final passwordcontroller = new TextEditingController();

  _saveServer() async {
    if (servercontroller.text != "" &&
        usernamecontroller.text != "" &&
        passwordcontroller.text != "") {
      String _serverURL = servercontroller.text;
      if (_serverURL.endsWith("/")) {
        _serverURL = _serverURL.substring(0, _serverURL.length - 1);
      }
      var status = await testServer(
          _serverURL, usernamecontroller.text, passwordcontroller.text);

      if (status) {
        final _randomNumber = generateRandomString();
        final _randomBytes =
            utf8.encode(passwordcontroller.text.toString() + _randomNumber);
        final _randomString = md5.convert(_randomBytes).toString();

        ServerInfo _serverInfo = ServerInfo(
            baseurl: _serverURL,
            username: usernamecontroller.text.toString(),
            salt: _randomNumber,
            hash: _randomString);
        await BaseDB.instance.addServerInfo(_serverInfo);
        //初始化服务器
        await getGenresFromNet();
        await getArtistsFromNet();
        await sacnServerStatus();

        isServers.value = true;
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return MyDialog(noticeLocal, servererrLocal);
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return MyDialog(noticeLocal, contenterrLocal);
        },
      );
    }
  }

  _getServerInfo() async {
    final _infoList = await BaseDB.instance.getServerInfo();
    if (_infoList != null) {
      if (mounted) {
        setState(() {
          isServers.value = true;
          servercontroller.text = _infoList.baseurl;
          usernamecontroller.text = _infoList.username;
          passwordcontroller.text = "******";
        });
      }
    }
  }

  _deleteServer() async {
    await BaseDB.instance.deleteServerInfo();
    if (mounted) {
      setState(() {
        isServers.value = false;
        servercontroller.text = "";
        usernamecontroller.text = "";
        passwordcontroller.text = "";
      });
    }
  }

  @override
  initState() {
    super.initState();
    _getServerInfo();
  }

  @override
  void dispose() {
    servercontroller.dispose();
    usernamecontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RightHeader(
      top: 102,
      headerWidget: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(settingsLocal, style: titleText1),
            TextButtom(
              press: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return MyDialog("尚未完工", "敬请期待");
                  },
                );
              },
              title: versionLocal + version,
              isActive: false,
            )
          ],
        ),
        SizedBox(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TextButtom(
                  press: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return MyDialog("尚未完工", "敬请期待");
                      },
                    );
                  },
                  title: "回放",
                  isActive: false,
                ),
                SizedBox(
                  width: 10,
                ),
                TextButtom(
                  press: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return MyDialog("尚未完工", "敬请期待");
                      },
                    );
                  },
                  title: "外观和风格",
                  isActive: false,
                ),
                SizedBox(
                  width: 10,
                ),
                TextButtom(
                  press: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return MyDialog("尚未完工", "敬请期待");
                      },
                    );
                  },
                  title: "其他",
                  isActive: true,
                )
              ],
            ),
            Row(
              children: [
                TextButtom(
                  press: () async {
                    //初始化服务器
                    await getGenresFromNet();
                    await getArtistsFromNet();
                    await sacnServerStatus();
                  },
                  title: "强制更新",
                  isActive: false,
                ),
                SizedBox(
                  width: 10,
                ),
                TextButtom(
                  press: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return MyDialog("尚未完工", "敬请期待");
                      },
                    );
                  },
                  title: "恢复默认",
                  isActive: false,
                ),
                SizedBox(
                  width: 10,
                ),
                TextButtom(
                  press: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return MyDialog("尚未完工", "敬请期待");
                      },
                    );
                  },
                  title: versionLocal,
                  isActive: false,
                )
              ],
            )
          ],
        )
      ]),
      contentWidget: Container(
          padding: allPadding,
          margin: allPadding,
          decoration: circularBorder,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    serverLocal,
                    style: titleText2,
                  ),
                  ValueListenableBuilder<bool>(
                      valueListenable: isServers,
                      builder: ((context, _value, child) {
                        return TextButtom(
                          press: () {
                            _value ? _deleteServer() : _saveServer();
                          },
                          title: _value ? unConnectLocal : saveLocal,
                          isActive: false,
                        );
                      }))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              MyTextInput(
                control: servercontroller,
                label: serverURLLocal,
                hintLabel: pleasInputLocal + serverURLLocal,
                hideText: false,
                icon: Icons.dns,
                titleStyle: nomalGrayText,
                mainaxis: MainAxisAlignment.spaceBetween,
                crossaxis: CrossAxisAlignment.center,
              ),
              MyTextInput(
                control: usernamecontroller,
                label: userNameLocal,
                hintLabel: pleasInputLocal + userNameLocal,
                hideText: false,
                icon: Icons.person,
                press: null,
                titleStyle: nomalGrayText,
                mainaxis: MainAxisAlignment.spaceBetween,
                crossaxis: CrossAxisAlignment.center,
              ),
              MyTextInput(
                control: passwordcontroller,
                label: passWordLocal,
                hintLabel: pleasInputLocal + passWordLocal,
                hideText: true,
                icon: Icons.password,
                press: null,
                titleStyle: nomalGrayText,
                mainaxis: MainAxisAlignment.spaceBetween,
                crossaxis: CrossAxisAlignment.center,
              ),
            ],
          )),
    );
  }
}
