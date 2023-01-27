import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import '../../util/dbProvider.dart';
import '../../util/handling.dart';
import '../../util/httpClient.dart';
import '../../util/util.dart';
import '../common/myAlertDialog.dart';
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
  String _selectedSort = 'en';
  List<DropdownMenuItem<String>> _sortItems = [];

  List<Tab> myTabs = <Tab>[
    Tab(text: ""),
    Tab(text: ''),
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
        isServersInfo.value = _serverInfo;
        await sacnServerStatus();
        initialize();
      } else {
        showMyAlertDialog(
            context, S.of(context).notive, S.of(context).serverErr);
      }
    } else {
      showMyAlertDialog(context, S.of(context).notive, S.of(context).noContent);
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
      isServersInfo.value = _myServerInfo;
      showMyAlertDialog(context, S.of(context).success,
          S.of(context).save + S.of(context).success);
    } else {
      showMyAlertDialog(context, S.of(context).notive, S.of(context).noContent);
    }
  }

  _getServerInfo() async {
    final _infoList = await DbProvider.instance.getServerInfo();
    if (_infoList != null) {
      _myServerInfo = _infoList;
      if (mounted) {
        setState(() {
          isServersInfo.value = _infoList;
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
        isServersInfo.value = ServerInfo(
            baseurl: '', hash: '', neteaseapi: '', salt: '', username: '');
        servercontroller.text = "";
        usernamecontroller.text = "";
        passwordcontroller.text = "";
        neteasecontroller.text = "";
      });
    }
    showMyAlertDialog(context, S.of(context).success,
        S.of(context).server + S.of(context).delete);
  }

  @override
  initState() {
    super.initState();
    _getServerInfo();
    myTabs = <Tab>[
      Tab(text: S.current.server + S.current.settings),
      Tab(text: S.current.other + S.current.settings),
    ];
    tabController = TabController(length: myTabs.length, vsync: this);
    _sortItems = [
      DropdownMenuItem(
          value: "en", child: Text(S.current.english, style: nomalText)),
      DropdownMenuItem(
          value: "zh", child: Text(S.current.chinese, style: nomalText)),
      DropdownMenuItem(
          value: "zh_Hans",
          child: Text(S.current.simplified, style: nomalText)),
      DropdownMenuItem(
          value: "zh_Hant",
          child: Text(S.current.traditional, style: nomalText))
    ];
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
            Text(S.of(context).settings, style: titleText1),
            Row(
              children: [
                ValueListenableBuilder<ServerInfo>(
                    valueListenable: isServersInfo,
                    builder: ((context, _value, child) {
                      return _value.baseurl.isNotEmpty
                          ? MyTextButton(
                              press: () async {
                                initialize();
                                showMyAlertDialog(
                                    context,
                                    S.of(context).enforceRefresh,
                                    S.of(context).refresh);
                              },
                              title: S.of(context).enforceRefresh)
                          : Container();
                    })),
                SizedBox(
                  width: 10,
                ),
                MyTextButton(
                    press: () {
                      showMyAlertDialog(
                          context, S.of(context).version, version);
                    },
                    title: S.of(context).version + version)
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
                          S.of(context).song + S.of(context).server,
                          style: titleText2,
                        ),
                        ValueListenableBuilder<ServerInfo>(
                            valueListenable: isServersInfo,
                            builder: ((context, _value, child) {
                              return MyTextButton(
                                  press: () {
                                    _value.baseurl.isNotEmpty
                                        ? _deleteServer()
                                        : _saveServer();
                                  },
                                  title: _value.baseurl.isNotEmpty
                                      ? S.of(context).disConnect
                                      : S.of(context).save);
                            }))
                      ],
                    ),
                    Container(
                      child: Text(
                        S.of(context).serverSaveNotive,
                        style: subText,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MyTextInput(
                      control: servercontroller,
                      label: S.of(context).serverURL,
                      hintLabel:
                          S.of(context).pleaseInput + S.of(context).serverURL,
                      hideText: false,
                      icon: Icons.dns,
                      titleStyle: nomalText,
                      mainaxis: MainAxisAlignment.spaceBetween,
                      crossaxis: CrossAxisAlignment.center,
                      press: () {
                        _saveServer();
                      },
                    ),
                    MyTextInput(
                      control: usernamecontroller,
                      label: S.of(context).username,
                      hintLabel:
                          S.of(context).pleaseInput + S.of(context).username,
                      hideText: false,
                      icon: Icons.person,
                      press: () {
                        _saveServer();
                      },
                      titleStyle: nomalText,
                      mainaxis: MainAxisAlignment.spaceBetween,
                      crossaxis: CrossAxisAlignment.center,
                    ),
                    MyTextInput(
                      control: passwordcontroller,
                      label: S.of(context).password,
                      hintLabel:
                          S.of(context).pleaseInput + S.of(context).password,
                      hideText: true,
                      icon: Icons.password,
                      press: () {
                        _saveServer();
                      },
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
                          S.of(context).lyric + S.of(context).server,
                          style: titleText2,
                        ),
                        ValueListenableBuilder<ServerInfo>(
                            valueListenable: isServersInfo,
                            builder: ((context, _value, child) {
                              return _value.neteaseapi.isNotEmpty
                                  ? Container()
                                  : MyTextButton(
                                      press: () async {
                                        if (_value.baseurl.isNotEmpty) {
                                          _saveNetease();
                                        } else {
                                          showMyAlertDialog(
                                              context,
                                              S.of(context).notive,
                                              S.of(context).serverSaveFirst);
                                        }
                                      },
                                      title: S.of(context).save +
                                          S.of(context).lyric +
                                          S.of(context).server);
                            }))
                      ],
                    ),
                    Container(
                      child: Text(
                        S.of(context).serverSaveSub,
                        style: subText,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ), //网易api监听，再做个左侧菜单隐藏
                    MyTextInput(
                      control: neteasecontroller,
                      label: S.of(context).lyric + S.of(context).server,
                      hintLabel:
                          S.of(context).pleaseInput + S.of(context).serverURL,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).appearance + S.of(context).settings,
                      style: titleText2,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).language,
                      style: nomalText,
                    ),
                    Container(
                      decoration: circularBorder,
                      padding: EdgeInsets.only(
                          left: 10, top: 5, right: 10, bottom: 5),
                      width: 200,
                      height: 35,
                      child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: badgeDark,
                          ),
                          child: DropdownButton(
                            value: _selectedSort,
                            items: _sortItems,
                            isDense: true,
                            isExpanded: true,
                            underline: Container(),
                            onChanged: (value) {
                              switch (value) {
                                case "en":
                                  S.load(Locale('en', ''));
                                  break;
                                case "zh":
                                  S.load(Locale('zh', ''));
                                  break;
                                case "zh_Hans":
                                  S.load(Locale('zh', 'Hans'));
                                  break;
                                case "zh_Hant":
                                  S.load(Locale('zh', 'Hant'));
                                  break;
                                default:
                              }
                              setState(() {
                                _selectedSort = value.toString();
                                myTabs = <Tab>[
                                  Tab(
                                      text: S.current.server +
                                          S.current.settings),
                                  Tab(
                                      text:
                                          S.current.other + S.current.settings),
                                ];
                              });
                            },
                          )),
                    )
                  ],
                ),
              ],
            ))
      ]),
    );
  }
}
