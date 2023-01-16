import 'dart:async';
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
import '../common/myAlertDialog.dart';
import '../common/myLoadingDialog.dart';
import '../common/myTextInput.dart';
import '../common/myStructure.dart';
import '../common/myToast.dart';
import '../common/textButtom.dart';

class Settings extends StatefulWidget {
  const Settings({
    Key? key,
  }) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
    with SingleTickerProviderStateMixin {
  final servercontroller = new TextEditingController();
  final usernamecontroller = new TextEditingController();
  final passwordcontroller = new TextEditingController();
  final neteasecontroller = new TextEditingController();
  late TabController tabController;
  late ServerInfo _myServerInfo;
  static const List<Tab> myTabs = <Tab>[
    Tab(text: '音乐服务器'),
    Tab(text: '歌词服务器'),
  ];

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
            hash: _randomString,
            neteaseapi: "");
        await BaseDB.instance.addServerInfo(_serverInfo);
        //初始化服务器
        showMyLoadingDialog(context, "初始化中...");
        //初始化服务器
        await getGenresFromNet();
        await getArtistsFromNet();
        await sacnServerStatus();
        Navigator.pop(context);

        isServers.value = true;
      } else {
        showMyAlertDialog(context, noticeLocal, servererrLocal);
      }
    } else {
      showMyAlertDialog(context, noticeLocal, contenterrLocal);
    }
  }

  _saveNetease() async {
    if (neteasecontroller.text != "" &&
        servercontroller.text == _myServerInfo.baseurl &&
        usernamecontroller.text == _myServerInfo.username) {
      String _serverURL = neteasecontroller.text;
      if (_serverURL.endsWith("/")) {
        _serverURL = _serverURL.substring(0, _serverURL.length - 1);
      }

      _myServerInfo.neteaseapi = _serverURL;
      await BaseDB.instance.updateServerInfo(_myServerInfo);
    } else {
      showMyAlertDialog(context, noticeLocal, contenterrLocal);
    }
  }

  _getServerInfo() async {
    final _infoList = await BaseDB.instance.getServerInfo();
    if (_infoList != null) {
      _myServerInfo = _infoList;
      if (mounted) {
        setState(() {
          isServers.value = true;
          servercontroller.text = _infoList.baseurl;
          usernamecontroller.text = _infoList.username;
          passwordcontroller.text = "******";
          neteasecontroller.text = _infoList.neteaseapi;
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
        neteasecontroller.text = "";
      });
    }
  }

  @override
  initState() {
    super.initState();
    _getServerInfo();
    tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    servercontroller.dispose();
    usernamecontroller.dispose();
    passwordcontroller.dispose();
    tabController.dispose();
    neteasecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
      top: 110,
      headerWidget: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(settingsLocal, style: titleText1),
            Row(
              children: [
                TextButtom(
                  press: () async {
                    showMyLoadingDialog(context, "更新中...");
                    //初始化服务器
                    await getGenresFromNet();
                    await getArtistsFromNet();
                    await sacnServerStatus();
                    Navigator.pop(context);
                  },
                  title: "强制更新",
                  isActive: false,
                ),
                SizedBox(
                  width: 10,
                ),
                TextButtom(
                  press: () {
                    showMyAlertDialog(context, "尚未完工", "敬请期待");
                    //showMyToast(context, "sssss");
                    //showMyLoadingDialog(context, "初始化中...");
                  },
                  title: versionLocal + version,
                  isActive: false,
                )
              ],
            )
          ],
        ),
        Container(
            alignment: Alignment.topLeft,
            child: TabBar(
                controller: tabController,
                labelColor: kGrayColor,
                unselectedLabelColor: borderColor,
                tabs: myTabs,
                isScrollable: true,
                indicatorColor: badgeDark)),
      ]),
      contentWidget: TabBarView(controller: tabController, children: [
        Container(
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
                      "音乐服务器",
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
        Container(
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
                      "歌词服务器",
                      style: titleText2,
                    ),
                    TextButtom(
                      press: () async {
                        _saveNetease();
                      },
                      title: "保存歌词服务器",
                      isActive: false,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                MyTextInput(
                  control: neteasecontroller,
                  label: "歌词服务器",
                  hintLabel: pleasInputLocal + serverURLLocal,
                  hideText: false,
                  icon: Icons.dns,
                  titleStyle: nomalGrayText,
                  mainaxis: MainAxisAlignment.spaceBetween,
                  crossaxis: CrossAxisAlignment.center,
                ),
              ],
            ))
      ]),
    );
  }
}
