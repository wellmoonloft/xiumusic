// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Xiu Music`
  String get appName {
    return Intl.message(
      'Xiu Music',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Confrim`
  String get confrim {
    return Intl.message(
      'Confrim',
      name: 'confrim',
      desc: '',
      args: [],
    );
  }

  /// `Save `
  String get save {
    return Intl.message(
      'Save ',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Cancel `
  String get cancel {
    return Intl.message(
      'Cancel ',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Notive`
  String get notive {
    return Intl.message(
      'Notive',
      name: 'notive',
      desc: '',
      args: [],
    );
  }

  /// `Delete `
  String get delete {
    return Intl.message(
      'Delete ',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Server Err`
  String get serverErr {
    return Intl.message(
      'Server Err',
      name: 'serverErr',
      desc: '',
      args: [],
    );
  }

  /// `No Contents`
  String get noContent {
    return Intl.message(
      'No Contents',
      name: 'noContent',
      desc: '',
      args: [],
    );
  }

  /// `Artist`
  String get artist {
    return Intl.message(
      'Artist',
      name: 'artist',
      desc: '',
      args: [],
    );
  }

  /// `Album`
  String get album {
    return Intl.message(
      'Album',
      name: 'album',
      desc: '',
      args: [],
    );
  }

  /// `Song `
  String get song {
    return Intl.message(
      'Song ',
      name: 'song',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get year {
    return Intl.message(
      'Year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `Dration`
  String get dration {
    return Intl.message(
      'Dration',
      name: 'dration',
      desc: '',
      args: [],
    );
  }

  /// `Play Count`
  String get playCount {
    return Intl.message(
      'Play Count',
      name: 'playCount',
      desc: '',
      args: [],
    );
  }

  /// `Bit Range`
  String get bitRange {
    return Intl.message(
      'Bit Range',
      name: 'bitRange',
      desc: '',
      args: [],
    );
  }

  /// `Refresh...`
  String get refresh {
    return Intl.message(
      'Refresh...',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Enforce Refresh`
  String get enforceRefresh {
    return Intl.message(
      'Enforce Refresh',
      name: 'enforceRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Upper Level`
  String get upLevel {
    return Intl.message(
      'Upper Level',
      name: 'upLevel',
      desc: '',
      args: [],
    );
  }

  /// `Name `
  String get name {
    return Intl.message(
      'Name ',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Genres`
  String get genres {
    return Intl.message(
      'Genres',
      name: 'genres',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Scan `
  String get scan {
    return Intl.message(
      'Scan ',
      name: 'scan',
      desc: '',
      args: [],
    );
  }

  /// `Server `
  String get server {
    return Intl.message(
      'Server ',
      name: 'server',
      desc: '',
      args: [],
    );
  }

  /// `Disconnect`
  String get disConnect {
    return Intl.message(
      'Disconnect',
      name: 'disConnect',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Please Input `
  String get pleaseInput {
    return Intl.message(
      'Please Input ',
      name: 'pleaseInput',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Server Address`
  String get serverURL {
    return Intl.message(
      'Server Address',
      name: 'serverURL',
      desc: '',
      args: [],
    );
  }

  /// `Index`
  String get index {
    return Intl.message(
      'Index',
      name: 'index',
      desc: '',
      args: [],
    );
  }

  /// `Playing`
  String get playing {
    return Intl.message(
      'Playing',
      name: 'playing',
      desc: '',
      args: [],
    );
  }

  /// `Playlist `
  String get playlist {
    return Intl.message(
      'Playlist ',
      name: 'playlist',
      desc: '',
      args: [],
    );
  }

  /// `Favorite`
  String get favorite {
    return Intl.message(
      'Favorite',
      name: 'favorite',
      desc: '',
      args: [],
    );
  }

  /// `Search `
  String get search {
    return Intl.message(
      'Search ',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Add `
  String get add {
    return Intl.message(
      'Add ',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Create `
  String get create {
    return Intl.message(
      'Create ',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `Lyric `
  String get lyric {
    return Intl.message(
      'Lyric ',
      name: 'lyric',
      desc: '',
      args: [],
    );
  }

  /// `Other `
  String get other {
    return Intl.message(
      'Other ',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Initialize...`
  String get initialize {
    return Intl.message(
      'Initialize...',
      name: 'initialize',
      desc: '',
      args: [],
    );
  }

  /// `Success `
  String get success {
    return Intl.message(
      'Success ',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Failure`
  String get failure {
    return Intl.message(
      'Failure',
      name: 'failure',
      desc: '',
      args: [],
    );
  }

  /// `Result`
  String get result {
    return Intl.message(
      'Result',
      name: 'result',
      desc: '',
      args: [],
    );
  }

  /// `Need to save the songs servers for use`
  String get serverSaveNotive {
    return Intl.message(
      'Need to save the songs servers for use',
      name: 'serverSaveNotive',
      desc: '',
      args: [],
    );
  }

  /// `Need to save the songs servers first`
  String get serverSaveFirst {
    return Intl.message(
      'Need to save the songs servers first',
      name: 'serverSaveFirst',
      desc: '',
      args: [],
    );
  }

  /// `The search lyrics button will only appear after saving the lyrics server`
  String get serverSaveSub {
    return Intl.message(
      'The search lyrics button will only appear after saving the lyrics server',
      name: 'serverSaveSub',
      desc: '',
      args: [],
    );
  }

  /// `Random `
  String get random {
    return Intl.message(
      'Random ',
      name: 'random',
      desc: '',
      args: [],
    );
  }

  /// `Most `
  String get most {
    return Intl.message(
      'Most ',
      name: 'most',
      desc: '',
      args: [],
    );
  }

  /// `Last `
  String get last {
    return Intl.message(
      'Last ',
      name: 'last',
      desc: '',
      args: [],
    );
  }

  /// `Play `
  String get play {
    return Intl.message(
      'Play ',
      name: 'play',
      desc: '',
      args: [],
    );
  }

  /// `Create User`
  String get createuser {
    return Intl.message(
      'Create User',
      name: 'createuser',
      desc: '',
      args: [],
    );
  }

  /// `Update Date`
  String get udpateDate {
    return Intl.message(
      'Update Date',
      name: 'udpateDate',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `No `
  String get no {
    return Intl.message(
      'No ',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Binding `
  String get binding {
    return Intl.message(
      'Binding ',
      name: 'binding',
      desc: '',
      args: [],
    );
  }

  /// `Top `
  String get top {
    return Intl.message(
      'Top ',
      name: 'top',
      desc: '',
      args: [],
    );
  }

  /// `More `
  String get more {
    return Intl.message(
      'More ',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `Less `
  String get less {
    return Intl.message(
      'Less ',
      name: 'less',
      desc: '',
      args: [],
    );
  }

  /// `Have `
  String get have {
    return Intl.message(
      'Have ',
      name: 'have',
      desc: '',
      args: [],
    );
  }

  /// `Lyric Download Success,Please check it and Binding`
  String get lyricDownloadSuccess {
    return Intl.message(
      'Lyric Download Success,Please check it and Binding',
      name: 'lyricDownloadSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Infomation`
  String get info {
    return Intl.message(
      'Infomation',
      name: 'info',
      desc: '',
      args: [],
    );
  }

  /// `My `
  String get my {
    return Intl.message(
      'My ',
      name: 'my',
      desc: '',
      args: [],
    );
  }

  /// `Net `
  String get net {
    return Intl.message(
      'Net ',
      name: 'net',
      desc: '',
      args: [],
    );
  }

  /// `Similar `
  String get similar {
    return Intl.message(
      'Similar ',
      name: 'similar',
      desc: '',
      args: [],
    );
  }

  /// `Appearance `
  String get appearance {
    return Intl.message(
      'Appearance ',
      name: 'appearance',
      desc: '',
      args: [],
    );
  }

  /// `Language `
  String get language {
    return Intl.message(
      'Language ',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Chinese`
  String get chinese {
    return Intl.message(
      'Chinese',
      name: 'chinese',
      desc: '',
      args: [],
    );
  }

  /// `Simplified`
  String get simplified {
    return Intl.message(
      'Simplified',
      name: 'simplified',
      desc: '',
      args: [],
    );
  }

  /// `Traditional`
  String get traditional {
    return Intl.message(
      'Traditional',
      name: 'traditional',
      desc: '',
      args: [],
    );
  }

  /// `Repeat One`
  String get repeatone {
    return Intl.message(
      'Repeat One',
      name: 'repeatone',
      desc: '',
      args: [],
    );
  }

  /// `Repeat All`
  String get repeatall {
    return Intl.message(
      'Repeat All',
      name: 'repeatall',
      desc: '',
      args: [],
    );
  }

  /// `Repeat Shuffle`
  String get shuffle {
    return Intl.message(
      'Repeat Shuffle',
      name: 'shuffle',
      desc: '',
      args: [],
    );
  }

  /// `Play Queue`
  String get playqueue {
    return Intl.message(
      'Play Queue',
      name: 'playqueue',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Expires`
  String get expires {
    return Intl.message(
      'Expires',
      name: 'expires',
      desc: '',
      args: [],
    );
  }

  /// `Visit`
  String get visitCount {
    return Intl.message(
      'Visit',
      name: 'visitCount',
      desc: '',
      args: [],
    );
  }

  /// `to`
  String get to {
    return Intl.message(
      'to',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `clipboard`
  String get clipboard {
    return Intl.message(
      'clipboard',
      name: 'clipboard',
      desc: '',
      args: [],
    );
  }

  /// `link `
  String get link {
    return Intl.message(
      'link ',
      name: 'link',
      desc: '',
      args: [],
    );
  }

  /// `qrCode `
  String get qrCode {
    return Intl.message(
      'qrCode ',
      name: 'qrCode',
      desc: '',
      args: [],
    );
  }

  /// `download `
  String get download {
    return Intl.message(
      'download ',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `directory`
  String get directory {
    return Intl.message(
      'directory',
      name: 'directory',
      desc: '',
      args: [],
    );
  }

  /// `PhotoLibrary`
  String get photoLibrary {
    return Intl.message(
      'PhotoLibrary',
      name: 'photoLibrary',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
