import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/httpClient.dart';
import '../../util/mycss.dart';
import '../common/myStructure.dart';

class ArtistsScreen extends StatefulWidget {
  const ArtistsScreen({Key? key}) : super(key: key);
  @override
  _ArtistsScreenState createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
  List? _artists;
  int artistsnum = 0;

  _getArtists() async {
    if (_artists == null) {
      final _artistsList = await getArtists();
      if (_artistsList != null) {
        List<Artists> _list = [];
        for (var _element in _artistsList["index"]) {
          var _temp = _element["artist"];
          for (var element in _temp) {
            String _url = getCoverArt(element["id"]);
            element["artistImageUrl"] = _url;
            Artists _artist = Artists.fromJson(element);
            _list.add(_artist);
          }
        }
        if (mounted) {
          setState(() {
            _artists = _list;
            artistsnum = _artists!.length;
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

  Widget _buildTopWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(child: Text(S.of(context).artist, style: titleText1)),
        Container(
          child: Text(
            S.of(context).artist + ": " + artistsnum.toString(),
            style: nomalText,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderWidget() {
    List<String> _title = [S.of(context).artist, S.of(context).album];
    return myRowList(_title, subText);
  }

  Widget _itemBuildWidget() {
    return _artists != null && _artists!.length > 0
        ? MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _artists!.length,
                itemExtent: 50.0, //强制高度为50.0
                itemBuilder: (BuildContext context, int index) {
                  Artists _tem = _artists![index];
                  List<String> _title = [_tem.name, _tem.albumCount.toString()];
                  return ListTile(
                      title: InkWell(
                          onTap: () {
                            activeID.value = _tem.id;
                            indexValue.value = 9;
                          },
                          child: myRowList(_title, nomalText)));
                }))
        : Container();
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
