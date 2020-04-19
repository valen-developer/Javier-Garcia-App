import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

import '../models/videos_model.dart';
import '../provider/youtube_provider.dart';
import '../widgets/data_error_widget.dart';
import '../widgets/progress_no_data_widget.dart';

class VideosPage extends StatelessWidget {
  final YoutubeProvider youtubeProvider = YoutubeProvider();

  @override
  Widget build(BuildContext context) {
    String playlistId, urlImage, title;
    List arguments = ModalRoute.of(context).settings.arguments;
    playlistId = arguments[0];
    urlImage = arguments[1];
    title = arguments[2];
    return Scaffold(
      body: _buildFutureBuilder(playlistId, title, urlImage),
    );
  }

  FutureBuilder<List<VideosModel>> _buildFutureBuilder(String playlistId, String title, String urlImage) {
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
        List<VideosModel> videos = snapshot.data;

        if (snapshot.hasData) {
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
            returned,
          ],
        );
      },
    );
  }

  SliverList _buildSliverList(List<VideosModel> videos) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
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
      }, childCount: videos.length),
    );
  }
}
