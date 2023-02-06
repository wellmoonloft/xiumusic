import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/httpClient.dart';
import '../../util/util.dart';
import '../../util/mycss.dart';
import '../common/myStructure.dart';
import '../common/myToast.dart';

class ShareListScreen extends StatefulWidget {
  const ShareListScreen({Key? key}) : super(key: key);
  @override
  _ShareListScreenState createState() => _ShareListScreenState();
}

class _ShareListScreenState extends State<ShareListScreen> {
  List<Sharelist> _sharelistsList = [];
  int _playlistnum = 0;

  _getShares() async {
    final _sharelists = await getShares();
    _sharelistsList.clear();
    if (_sharelists != null && _sharelists.length > 0) {
      for (var element in _sharelists) {
        Sharelist _sharelist = Sharelist.fromJson(element);
        _sharelistsList.add(_sharelist);
      }
      if (mounted) {
        setState(() {
          _playlistnum = _sharelistsList.length;
        });
      }
    }
  }

  //to share qrcode need three dependencies,and add permission in ios/android
  //  qr_flutter: ^4.0.0
  //  path_provider: ^2.0.12
  //  gallery_saver: ^2.3.2
  // _createQRcode(Sharelist _tem) async {
  //   final qrValidationResult = QrValidator.validate(
  //     data: _tem.url,
  //     version: QrVersions.auto,
  //     errorCorrectionLevel: QrErrorCorrectLevel.L,
  //   );
  //   if (qrValidationResult.status == QrValidationStatus.valid) {
  //     QrCode? qrCode = qrValidationResult.qrCode;
  //     if (qrCode != null) {
  //       final painter = QrPainter.withQr(
  //         qr: qrCode,
  //         color: const Color(0xFF000000),
  //         gapless: true,
  //         embeddedImageStyle: null,
  //         embeddedImage: null,
  //       );
  //       if (isMobile) {
  //         Directory tempDir = await getTemporaryDirectory();

  //         String tempPath = tempDir.path;
  //         String ts = _tem.description;
  //         String path = '$tempPath/$ts.png';
  //         final picData = await painter.toImageData(2048);
  //         if (picData != null) {
  //           await writeToFile(picData, path);
  //           final success = await GallerySaver.saveImage(path);
  //           if (success != null && success) {
  //             MyToast.show(
  //                 context: context,
  //                 message:
  //                     S.current.save + S.current.to + S.current.photoLibrary);
  //           }
  //         }
  //       } else {
  //         Directory? tempDir = await getDownloadsDirectory();
  //         if (tempDir != null) {
  //           String tempPath = tempDir.path;
  //           String ts = _tem.description;
  //           String path = '$tempPath/$ts.png';
  //           final picData = await painter.toImageData(2048);
  //           if (picData != null) {
  //             await writeToFile(picData, path);
  //             MyToast.show(
  //                 context: context,
  //                 message: S.current.save +
  //                     S.current.to +
  //                     S.current.download +
  //                     S.current.directory);
  //           }
  //         }
  //       }
  //     }
  //   } else {
  //     print(qrValidationResult.error);
  //   }
  // }

  // Future<void> writeToFile(ByteData data, String path) async {
  //   final buffer = data.buffer;
  //   await File(path).writeAsBytes(
  //       buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  // }

  _delShare(BuildContext context, double _x, double _y, String _playlistId) {
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(_x, _y, _x, _y),
        items: [
          PopupMenuItem(
            child: Text(S.current.delete + S.current.share),
            value: _playlistId.toString(),
          ),
        ]).then((value) async {
      if (value != null) {
        await deleteShare(_playlistId);

        MyToast.show(
            context: context, message: S.current.delete + S.current.success);
        _getShares();
      }
    });
  }

  @override
  initState() {
    super.initState();
    _getShares();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _sharelistBody() {
    return _sharelistsList.length > 0
        ? MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _sharelistsList.length,
                itemExtent: 50.0, //强制高度为50.0
                itemBuilder: (BuildContext context, int index) {
                  Sharelist _tem = _sharelistsList[index];
                  List<String> _title = [
                    _tem.description,
                    timeISOtoString(_tem.created),
                    timeISOtoString(_tem.expires),
                    _tem.visitCount.toString()
                  ];
                  return Dismissible(
                      // Key
                      key: Key(_tem.id),
                      confirmDismiss: (direction) {
                        bool _result = false;
                        if (direction == DismissDirection.endToStart) {
                          // 从右向左  也就是删除
                          _result = true;
                        } else if (direction == DismissDirection.startToEnd) {
                          //从左向右
                          _result = false;
                        }
                        return Future<bool>.value(_result);
                      },
                      onDismissed: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          await deleteShare(_tem.id);
                          _getShares();
                          MyToast.show(
                              context: context,
                              message: S.current.delete + S.current.success);
                        } else if (direction == DismissDirection.startToEnd) {
                          //从左向右
                        }
                      },
                      background: Container(
                        color: rightColor,
                        child: ListTile(
                            // leading: Icon(
                            //   Icons.delete,
                            //   color: textGray,
                            // ),
                            ),
                      ),
                      secondaryBackground: Container(
                        color: badgeRed,
                        child: ListTile(
                          trailing: Icon(
                            Icons.delete,
                            color: textGray,
                          ),
                        ),
                      ),
                      child: ListTile(
                          title: GestureDetector(
                              onTap: () async {
                                showShareDialog(_tem, context);
                              },
                              onSecondaryTapDown: (details) {
                                _delShare(context, details.globalPosition.dx,
                                    details.globalPosition.dy, _tem.id);
                              },
                              child: ValueListenableBuilder<Map>(
                                  valueListenable: activeSong,
                                  builder: ((context, value, child) {
                                    return myRowList(_title, nomalText);
                                  })))));
                }))
        : Container();
  }

  Widget _sharelistHeader() {
    List<String> _title = [
      S.current.name,
      S.current.create,
      S.current.expires,
      S.current.visitCount
    ];
    return myRowList(_title, subText);
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
        top: 90,
        headerWidget: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Container(
                    child: Text(S.current.share, style: titleText1),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    padding:
                        EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 3),
                    decoration: BoxDecoration(
                        color: badgeDark,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6))),
                    child: Text(
                      _playlistnum.toString(),
                      style: nomalText,
                    ),
                  )
                ]),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            _sharelistHeader(),
          ],
        ),
        contentWidget: _sharelistBody());
  }
}
