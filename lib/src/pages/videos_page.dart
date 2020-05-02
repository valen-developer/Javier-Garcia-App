import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

import '../models/videos_model.dart';
import '../provider/youtube_provider.dart';
import '../widgets/data_error_widget.dart';
import '../widgets/progress_no_data_widget.dart';

class VideosPage extends StatefulWidget {
  @override
  _VideosPageState createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  final YoutubeProvider youtubeProvider = YoutubeProvider();
  TextEditingController _textEditingController;
  List<VideosModel> videos;
  List<VideosModel> duplicateVideos;
  bool chargedData = false;

  @override
  void initState() {
    videos = List<VideosModel>();
    duplicateVideos = List<VideosModel>();
    _textEditingController = TextEditingController();
    super.initState();
  }

  _filterSearch(String query) {
    List<VideosModel> tempSearchList = List<VideosModel>();
    tempSearchList.addAll(duplicateVideos);
    if (query.isNotEmpty) {
      List<VideosModel> tempSearchData = List<VideosModel>();
      tempSearchList.forEach((item) {
        String title = item.title;
        title = title.toLowerCase();
        if (title.contains(query.toLowerCase())) {
          tempSearchData.add(item);
        }
      });

      setState(() {
        videos.clear();
        videos.addAll(tempSearchData);
      });
      return;
    } else {
      setState(() {
        videos.clear();
        videos.addAll(duplicateVideos);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    String playlistId, urlImage, title;
    List arguments = ModalRoute.of(context).settings.arguments;
    playlistId = arguments[0];
    urlImage = arguments[1];
    title = arguments[2];
    return Scaffold(
      body: _buildFutureBuilder(playlistId, title, urlImage, size),
    );
  }

  FutureBuilder<List<VideosModel>> _buildFutureBuilder(
      String playlistId, String title, String urlImage, Size size) {
    return FutureBuilder(
      future: youtubeProvider.getVideos(playlistId),
      builder: (context, AsyncSnapshot<List<VideosModel>> snapshot) {
        var returned;

        if (snapshot.hasError) {
          print(snapshot.error);
          return DataError();
        }

        if (!snapshot.hasData) {
          returned = ProgressNoData();
        }

        if (snapshot.hasData) {
          duplicateVideos = snapshot.data;
          if (!chargedData) {
            videos = duplicateVideos;
            chargedData = true;
          }

          returned = _buildSliverList(videos);
        }

        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              centerTitle: true,
              pinned: true,
              title: Text(title),
              backgroundColor: Colors.black,
              forceElevated: true,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Hero(
                  tag: playlistId,
                  child: Image.network(
                    urlImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(15),
                child: TextField(
                  onChanged: (value) {
                    _filterSearch(value);
                  },
                  controller: _textEditingController,
                  enableInteractiveSelection: true,
                  autofocus: false,
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                    hintText: "Buscar",
                    contentPadding: EdgeInsets.all(10),
                    labelText: "Buscar",
                    prefix: Icon(
                      Icons.search,
                      color: Colors.red,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ),
            ),
            returned,
          ],
        );
      },
    );
  }

  SliverList _buildSliverList(List<VideosModel> videos) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return ListTile(
            onTap: () {
              FlutterYoutube.playYoutubeVideoById(
                videoId: videos[index].id,
                backgroundColor: Colors.black,
                appBarColor: Colors.red,
                apiKey: "your api key",
                autoPlay: true,
              );
            },
            title: Text(videos[index].title),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(videos[index].url),
            ),
          );
        },
        childCount: videos.length,
      ),
    );
  }
}
