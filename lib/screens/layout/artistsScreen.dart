import 'package:flutter/material.dart';
import '../../util/baseDB.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../common/baseCSS.dart';
import '../../util/localizations.dart';
import '../common/myStructure.dart';

class ArtistsScreen extends StatefulWidget {
  const ArtistsScreen({Key? key}) : super(key: key);
  @override
  _ArtistsScreenState createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
  List? _artists;
  int artistsnum = 0;
  int albumsnum = 0;

  _getArtists() async {
    if (_artists == null) {
      final _artistsList = await BaseDB.instance.getArtists();
      if (_artistsList != null) {
        for (var element in _artistsList) {
          Artists _xx = element;
          albumsnum += _xx.albumCount;
        }
        if (mounted) {
          setState(() {
            _artists = _artistsList;
            artistsnum = _artistsList.length;
          });
        }
      }
    }
  }

  @override
  initState() {
    super.initState();
    _getArtists();
  }

  Widget _buildHeaderWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: 1,
            child: Container(
              child: Text(
                artistLocal,
                textDirection: TextDirection.ltr,
                style: sublGrayText,
              ),
            )),
        Expanded(
          flex: 1,
          child: Container(
              child: Text(
            albumLocal,
            textDirection: TextDirection.rtl,
            style: sublGrayText,
          )),
        )
      ],
    );
  }

  Widget _itemBuildWidget() {
    return _artists != null && _artists!.length > 0
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _artists!.length,
            itemExtent: 50.0, //强制高度为50.0
            itemBuilder: (BuildContext context, int index) {
              Artists _tem = _artists![index];
              return ListTile(
                  title: InkWell(
                      onTap: () {
                        //_getAlbums(_tem.id);
                        activeID.value = _tem.id;
                        indexValue.value = 9;
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              _tem.name,
                              textDirection: TextDirection.ltr,
                              style: nomalGrayText,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              _tem.albumCount.toString(),
                              textDirection: TextDirection.rtl,
                              style: nomalGrayText,
                            ),
                          ),
                        ],
                      )));
            })
        : Container();
  }

  Widget _buildTopWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(child: Text(artistLocal, style: titleText1)),
        Row(
          children: [
            Text(
              "艺人: " + artistsnum.toString(),
              style: nomalGrayText,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "$albumLocal: " + albumsnum.toString(),
              style: nomalGrayText,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
        top: 100,
        headerWidget: Column(
          children: [
            _buildTopWidget(),
            SizedBox(height: 25),
            _buildHeaderWidget()
          ],
        ),
        contentWidget: _itemBuildWidget());
  }
}
