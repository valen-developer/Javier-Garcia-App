import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/playlist_model.dart';
import '../models/videos_model.dart';

//UCYOv9HwOFwK0lY2dUQlZSpg -- channel ID javier garcia

class YoutubeProvider {
  String _url = "www.googleapis.com";
  String _key = "your api key";
  String _channelId = "UCYOv9HwOFwK0lY2dUQlZSpg";

  Future<bool> updatePlayList() async {
    /* Save list of playlist on davice´s storage due to Google quota (limited) */
    Directory dir = await getApplicationDocumentsDirectory();
    File dateFile = File("${dir.path}/update.json");
    File file = File("${dir.path}/playlist.json");

    /*Update list of playlist every 3 days*/
    if (dateFile.existsSync()) {
      DateTime time;

      if (dateFile.readAsStringSync().isEmpty) {
        time = DateTime.now();
        dateFile.writeAsStringSync(DateTime.now().toString());
      } else {
        time = DateTime.parse(dateFile.readAsStringSync());
      }

      DateTime now = DateTime.now();
      //Update if last update was more 3 days ago
      if (!((time.difference(now).inDays) <= -3)) {
        if (file.readAsStringSync().isEmpty) {
          print("Actualizams");
        } else {
          print("No actualizamos");
          return false;
        }
      }
    } else {
      dateFile.createSync();
    }

    //Existe el fichero que guarda la playlist?
    if (!file.existsSync()) {
      print("El archivo no existe: playlist.json");
      file.createSync();
    }

    print("============== ACTUALIZAMOS ==========");

    Uri uri = Uri.https(_url, "youtube/v3/playlists", {
      "part": "snippet",
      "channelId": _channelId,
      "key": _key,
      "maxResults": "50",
    });

    http.Response resp;
    try {
      resp = await http.get(uri);
    } catch (e) {
      getPlaylist();
      return false;
    }

    var json = jsonDecode(resp.body);

    List items = json["items"];
    List playlist = [];

    items.forEach((item) {
      playlist.add({
        "url": item["snippet"]["thumbnails"]["medium"]["url"],
        "title": item["snippet"]["title"],
        "id": item["id"]
      });
    });

    var jsontoSave = jsonEncode(playlist);

    dateFile.writeAsString(DateTime.now().toString());
    file.writeAsStringSync(jsontoSave);
    return true;
  }


  /*Get playlists from youtube */
  Future<List<PlayListModel>> getPlaylist() async {
    await updatePlayList();

    PlayListModelList playListModelList = PlayListModelList();
    Directory dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/playlist.json");

    var json = jsonDecode(file.readAsStringSync());

    playListModelList.fromJsonList(json);
    return playListModelList.items;
  }


  /*Update playlists´ videos from youtube */
  updateVideoList(String playlistId) async {
    /*Same that playlist´s list. Save in device´s storage and update every 3 days */
    Directory dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$playlistId.json");
    File dateUpdate = File("${dir.path}/date-$playlistId");

    if (!(await dateUpdate.exists())) {
      dateUpdate.createSync();
    }
    if (!(dateUpdate.readAsStringSync() == "")) {
      DateTime time = DateTime.parse(dateUpdate.readAsStringSync());

      DateTime now = DateTime.now();
      if (!((time.difference(now).inDays) <= -3)) {
        print("No actualizamos");
        return false;
      }
    }

    var json = await _getvideos("", playlistId);
    List items = json["items"];
    List videos = [];
    _addVideostoList(items, videos);
    while (json["nextPageToken"] != null) {
      json = await _getvideos(json["nextPageToken"], playlistId);
      items = json["items"];      
      _addVideostoList(items, videos);
    }

    var jsontoSave = jsonEncode(videos);
    file.writeAsStringSync(jsontoSave);
    dateUpdate.writeAsStringSync(DateTime.now().toString());
    return true;
  }

  void _addVideostoList(List items, List videos) {
    items.forEach((item) {
      videos.add({
        "id": item["snippet"]["resourceId"]["videoId"],
        "url": item["snippet"]["thumbnails"]["medium"]["url"],
        "title": item["snippet"]["title"]
      });
    });
  }

  Future<List<VideosModel>> getVideos(String playlistId) async {
    await updateVideoList(playlistId);

    VideosModelList videosModelList = VideosModelList();

    Directory dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$playlistId.json");

    var json = jsonDecode(file.readAsStringSync());
    videosModelList.fromJsonList(json);
    return videosModelList.items;
  }

  Future<dynamic> _getvideos(String pageToken, String playlistId) async {
    /*Make this function to get all page of playlist */
    print("============= ACTUALIZAMOS VIDEOS =============");
    Uri uri = Uri.https(_url, "youtube/v3/playlistItems", {
      "playlistId": playlistId,
      "key": _key,
      "part": "snippet",
      "maxResults": "50",
      "pageToken": pageToken
    });

    http.Response resp = await http.get(uri);
    var json = jsonDecode(resp.body);

    return json;
  }
}
