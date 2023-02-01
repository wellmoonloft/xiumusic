import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import '../../util/dbProvider.dart';
import '../../util/httpClient.dart';
import '../../util/util.dart';
import '../common/myAlertDialog.dart';
import '../common/myTextInput.dart';
import '../common/myTextButton.dart';
import '../leftScreen.dart';

class Settings extends StatefulWidget {
  const Settings({
    Key? key,
  }) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
    with SingleTickerProviderStateMixin {
  GlobalKey<LeftScreenState> leftScreen = GlobalKey();
  final servercontroller = new TextEditingController();
  final usernamecontroller = new TextEditingController();
  final passwordcontroller = new TextEditingController();
  final neteasecontroller = new TextEditingController();
  final taskTimecontroller = new TextEditingController();
  late ServerInfo _myServerInfo;
  String _selectedSort = 'en';
  List<DropdownMenuItem<String>> _sortItems = [];

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
            neteaseapi: "",
            languageCode: '');
        await DbProvider.instance.addServerInfo(_serverInfo);
        serversInfo.value = _serverInfo;
        indexValue.value = 0;
      } else {
        showMyAlertDialog(context, S.current.notive, S.current.serverErr);
      }
    } else {
      showMyAlertDialog(context, S.current.notive, S.current.noContent);
    }
  }

  _saveNetease() async {
    if (neteasecontroller.text != "") {
      String _serverURL = neteasecontroller.text;
      if (_serverURL.endsWith("/")) {
        _serverURL = _serverURL.substring(0, _serverURL.length - 1);
      }

      _myServerInfo.neteaseapi = _serverURL;
      await DbProvider.instance.updateServerInfo(_myServerInfo);
      //new一个对象触发值的监听
      ServerInfo newServerInfo = new ServerInfo(
          baseurl: _myServerInfo.baseurl,
          hash: _myServerInfo.hash,
          languageCode: _myServerInfo.languageCode,
          neteaseapi: _myServerInfo.neteaseapi,
          salt: _myServerInfo.salt,
          username: _myServerInfo.username);
      serversInfo.value = newServerInfo;
      showMyAlertDialog(
          context, S.current.success, S.current.save + S.current.success);
    } else {
      showMyAlertDialog(context, S.current.notive, S.current.noContent);
    }
  }

  _getServerInfo() async {
    final _infoList = await DbProvider.instance.getServerInfo();
    if (_infoList != null) {
      _myServerInfo = _infoList;
      if (mounted) {
        setState(() {
          _selectedSort = _myServerInfo.languageCode.isNotEmpty
              ? _myServerInfo.languageCode
              : "en";
          serversInfo.value = _infoList;
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
        serversInfo.value = ServerInfo(
            baseurl: '',
            hash: '',
            neteaseapi: '',
            salt: '',
            username: '',
            languageCode: '');
        servercontroller.text = "";
        usernamecontroller.text = "";
        passwordcontroller.text = "";
        neteasecontroller.text = "";
      });
    }
    showMyAlertDialog(
        context, S.current.success, S.current.server + S.current.delete);
  }

  @override
  initState() {
    super.initState();
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
    _getServerInfo();
  }

  @override
  void dispose() {
    servercontroller.dispose();
    usernamecontroller.dispose();
    passwordcontroller.dispose();
    neteasecontroller.dispose();
    taskTimecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[
      SliverToBoxAdapter(
          child: Container(
              padding: leftrightPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(S.current.settings, style: titleText1),
                  MyTextButton(
                      press: () {
                        showMyAlertDialog(context, S.current.version, version);
                      },
                      title: S.current.version)
                ],
              ))),
      SliverToBoxAdapter(
        child: Container(
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
                      S.current.song + S.current.server,
                      style: titleText2,
                    ),
                    ValueListenableBuilder<ServerInfo>(
                        valueListenable: serversInfo,
                        builder: ((context, _value, child) {
                          return MyTextButton(
                              press: () {
                                _value.baseurl.isNotEmpty
                                    ? _deleteServer()
                                    : _saveServer();
                              },
                              title: _value.baseurl.isNotEmpty
                                  ? S.current.disConnect
                                  : S.current.save);
                        }))
                  ],
                ),
                Container(
                  child: Text(
                    S.current.serverSaveNotive,
                    style: subText,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                MyTextInput(
                  control: servercontroller,
                  label: S.current.serverURL,
                  hintLabel: S.current.serverURL,
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
                  label: S.current.username,
                  hintLabel: S.current.username,
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
                  label: S.current.password,
                  hintLabel: S.current.password,
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
      ),
      SliverToBoxAdapter(
        child: Container(
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
                      S.current.lyric + S.current.server,
                      style: titleText2,
                    ),
                    ValueListenableBuilder<ServerInfo>(
                        valueListenable: serversInfo,
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
                                          S.current.notive,
                                          S.current.serverSaveFirst);
                                    }
                                  },
                                  title: S.current.save +
                                      S.current.lyric +
                                      S.current.server);
                        }))
                  ],
                ),
                Container(
                  child: Text(
                    S.current.serverSaveSub,
                    style: subText,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                MyTextInput(
                  control: neteasecontroller,
                  label: S.current.lyric + S.current.server,
                  hintLabel: S.current.serverURL,
                  hideText: false,
                  icon: Icons.dns,
                  titleStyle: nomalText,
                  mainaxis: MainAxisAlignment.spaceBetween,
                  crossaxis: CrossAxisAlignment.center,
                ),
              ],
            )),
      ),
      SliverToBoxAdapter(
        child: Container(
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
                      S.current.appearance + S.current.settings,
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
                      S.current.language,
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
                            onChanged: (value) async {
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
                              });

                              if (serversInfo.value.baseurl.isNotEmpty) {
                                _myServerInfo.languageCode = value.toString();
                                await DbProvider.instance
                                    .updateServerInfo(_myServerInfo);
                                //new一个对象触发值的监听
                                ServerInfo newServerInfo = new ServerInfo(
                                    baseurl: _myServerInfo.baseurl,
                                    hash: _myServerInfo.hash,
                                    languageCode: _myServerInfo.languageCode,
                                    neteaseapi: _myServerInfo.neteaseapi,
                                    salt: _myServerInfo.salt,
                                    username: _myServerInfo.username);
                                serversInfo.value = newServerInfo;
                              }
                            },
                          )),
                    )
                  ],
                ),
              ],
            )),
      ),
    ]);
  }
}
