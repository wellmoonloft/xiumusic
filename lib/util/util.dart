import 'dart:convert';
import 'dart:ui';
import 'dart:math';

import 'package:crypto/crypto.dart';

class ColorsUtil {
  /// 十六进制颜色，
  /// hex, 十六进制值，例如：0xffffff,
  /// alpha, 透明度 [0.0,1.0]
  static Color hexColor(int hex, {double alpha = 1}) {
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    return Color.fromRGBO((hex & 0xFF0000) >> 16, (hex & 0x00FF00) >> 8,
        (hex & 0x0000FF) >> 0, alpha);
  }
}

String md5RandomString(String _password) {
  final randomNumber = Random().toString();
  final randomBytes = utf8.encode(randomNumber + _password);
  final randomString = md5.convert(randomBytes).toString();
  return randomString;
}

DateTime timestampToDate(int timestamp) {
  DateTime dateTime = DateTime.now();

  ///如果是十三位时间戳返回这个
  if (timestamp.toString().length == 13) {
    dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  } else if (timestamp.toString().length == 16) {
    ///如果是十六位时间戳
    dateTime = DateTime.fromMicrosecondsSinceEpoch(timestamp);
  }
  return dateTime;
}

///时间戳转日期
///[timestamp] 时间戳
///[onlyNeedDate ] 是否只显示日期 舍去时间
String timestampToDateStr(int timestamp, {onlyNeedDate = false}) {
  DateTime dataTime = timestampToDate(timestamp);
  String dateTime = dataTime.toString();

  ///去掉时间后面的.000
  dateTime = dateTime.substring(0, dateTime.length - 4);
  if (onlyNeedDate) {
    List<String> dataList = dateTime.split(" ");
    dateTime = dataList[0];
  }
  return dateTime;
}

String timeISOtoString(String time) {
  DateTime y2k = DateTime.parse(time);
  //获取当前时间的年
  int year = y2k.year;
  //获取当前时间的月
  int month = y2k.month;
  //获取当前时间的日
  int day = y2k.day;
  return "$year-$month-$day";
}

String generateRandomString() {
  final _random = Random();
  const _availableChars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final randomString = List.generate(6,
          (index) => _availableChars[_random.nextInt(_availableChars.length)])
      .join();

  return randomString;
}

// Define the function
String formatDuration(int _duration) {
  Duration _dura = Duration(seconds: _duration);
  if (_dura.inHours != 0) {
    String hours = _dura.inHours.toString().padLeft(0, '2');
    String minutes = _dura.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = _dura.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  } else {
    String minutes = _dura.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = _dura.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}

String formatSongDuration(Duration _tmp) {
  if (_tmp.inHours != 0) {
    String hours = _tmp.inHours.toString().padLeft(0, '2');
    String minutes = _tmp.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = _tmp.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  } else {
    String minutes = _tmp.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = _tmp.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
