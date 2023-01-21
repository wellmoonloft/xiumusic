import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import '../../util/dbProvider.dart';
import '../../util/handling.dart';
import '../../util/httpClient.dart';
import '../../util/localizations.dart';
import '../../util/util.dart';
import '../common/myAlertDialog.dart';
import '../common/myLoadingDialog.dart';
import '../common/myTextInput.dart';
import '../common/myStructure.dart';
import '../common/myTextButton.dart';

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
  final taskTimecontroller = new TextEditingController();
  late TabController tabController;
  late ServerInfo _myServerInfo;
  static const List<Tab> myTabs = <Tab>[
    Tab(text: '服务器设置'),
    Tab(text: '其他设置'),
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
        await DbProvider.instance.addServerInfo(_serverInfo);
        //初始化服务器
        showMyLoadingDialog(context, "初始化中...");
        //初始化服务器
        await getGenresFromNet();
        await getArtistsFromNet();
        await sacnServerStatus();
        await getFavoriteFromNet();
        await getPlaylistsFromNet();
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
      await DbProvider.instance.updateServerInfo(_myServerInfo);
      isSNetease.value = true;
      showMyAlertDialog(context, "成功", "保存成功");
    } else {
      showMyAlertDialog(context, noticeLocal, contenterrLocal);
    }
  }

  _getServerInfo() async {
    final _infoList = await DbProvider.instance.getServerInfo();
    if (_infoList != null) {
      _myServerInfo = _infoList;
      if (_myServerInfo.neteaseapi.isNotEmpty) {
        isSNetease.value = true;
      }
      if (mounted) {
        setState(() {
          isServers.value = true;
          servercontroller.text = _myServerInfo.baseurl;
          usernamecontroller.text = _myServerInfo.username;
          passwordcontroller.text = "******";
          neteasecontroller.text = _myServerInfo.neteaseapi;
        });
      }
    }
  }

  _deleteServer() async {
    await DbProvider.instance.deleteServerInfo();
    if (mounted) {
      setState(() {
        isServers.value = false;
        servercontroller.text = "";
        usernamecontroller.text = "";
        passwordcontroller.text = "";
        neteasecontroller.text = "";
      });
    }
    showMyAlertDialog(context, "成功", "服务器已删除");
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
    taskTimecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
      top: 106,
      headerWidget: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(settingsLocal, style: titleText1),
            Row(
              children: [
                ValueListenableBuilder<bool>(
                    valueListenable: isServers,
                    builder: ((context, _value, child) {
                      return isServers.value
                          ? MyTextButton(
                              press: () async {
                                showMyLoadingDialog(context, "刷新中...");
                                //初始化服务器
                                await getGenresFromNet();
                                await getArtistsFromNet();
                                await sacnServerStatus();
                                await getFavoriteFromNet();
                                await getPlaylistsFromNet();
                                Navigator.pop(context);
                              },
                              title: "强制刷新")
                          : Container();
                    })),
                SizedBox(
                  width: 10,
                ),
                MyTextButton(
                    press: () {
                      showMyAlertDialog(context, "尚未完工", "敬请期待");
                      //showMyToast(context, "sssss");
                      //showMyLoadingDialog(context, "初始化中...");
                    },
                    title: versionLocal + version)
              ],
            )
          ],
        ),
        Container(
            alignment: Alignment.topLeft,
            child: TabBar(
                controller: tabController,
                labelColor: textGray,
                unselectedLabelColor: borderColor,
                tabs: myTabs,
                isScrollable: true,
                indicatorColor: badgeRed)),
      ]),
      contentWidget: TabBarView(controller: tabController, children: [
        Column(
          children: [
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
                              return MyTextButton(
                                  press: () {
                                    _value ? _deleteServer() : _saveServer();
                                  },
                                  title: _value ? unConnectLocal : saveLocal);
                            }))
                      ],
                    ),
                    Container(
                      child: Text(
                        "需要先行保存服务器之后才可以正常使用",
                        style: subText,
                      ),
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
                      titleStyle: nomalText,
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
                      titleStyle: nomalText,
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
                      titleStyle: nomalText,
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
                        ValueListenableBuilder<bool>(
                            valueListenable: isSNetease,
                            builder: ((context, _value, child) {
                              return _value
                                  ? Container()
                                  : MyTextButton(
                                      press: () async {
                                        if (isServers.value) {
                                          _saveNetease();
                                        } else {
                                          showMyAlertDialog(
                                              context, "提醒", "请先保存音乐服务器");
                                        }
                                      },
                                      title: "保存歌词服务器");
                            }))
                      ],
                    ),
                    Container(
                      child: Text(
                        "需要先行保存歌词服务器之后才才会出现搜索歌词按钮",
                        style: subText,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ), //网易api监听，再做个左侧菜单隐藏
                    MyTextInput(
                      control: neteasecontroller,
                      label: "歌词服务器",
                      hintLabel: pleasInputLocal + serverURLLocal,
                      hideText: false,
                      icon: Icons.dns,
                      titleStyle: nomalText,
                      mainaxis: MainAxisAlignment.spaceBetween,
                      crossaxis: CrossAxisAlignment.center,
                    ),
                  ],
                ))
          ],
        ),
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
                      "系统设置",
                      style: titleText2,
                    ),
                    MyTextButton(
                        press: () async {
                          showMyAlertDialog(
                              context, "提醒", "暂时未开放，默认不自动刷新，新增歌曲请点击手动刷新");
                        },
                        title: "保存设置"),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                MyTextInput(
                  control: taskTimecontroller,
                  label: "定时任务间隔时间",
                  hintLabel: pleasInputLocal + "间隔时间（分钟）",
                  hideText: false,
                  icon: Icons.watch_later,
                  titleStyle: nomalText,
                  keyboardType: TextInputType.number,
                  mainaxis: MainAxisAlignment.spaceBetween,
                  crossaxis: CrossAxisAlignment.center,
                ),
              ],
            ))
      ]),
    );
  }
}
