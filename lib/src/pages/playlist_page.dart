import 'package:flutter/material.dart';

import '../models/playlist_model.dart';
import '../provider/youtube_provider.dart';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/data_error_widget.dart';
import '../widgets/progress_no_data_widget.dart';

class PlayListPage extends StatefulWidget {
  @override
  _PlayListPageState createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  final YoutubeProvider youtubeProvider = YoutubeProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: _buildDrawer(),
      ),
      body: _buildFutureBuilder(),
    );
  }

  _buildDrawer() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            _buildPatreonButton(),
            SizedBox(
              height: 20,
            ),
            _buildRotateText(),
            SizedBox(
              height: 40,
            ),
            _buildTyperText(),
            _buildAbout()
          ],
        ),
      ),
    );
  }

  GestureDetector _buildPatreonButton() {
    return GestureDetector(
      onTap: () {
        launch("https://www.patreon.com/ceamontilivi");
      },
      child: CircleAvatar(
        backgroundImage: AssetImage(
          "assets/patreon1.png",
        ),
        maxRadius: 50,
        minRadius: 20,
      ),
    );
  }

  Expanded _buildAbout() {
    return Expanded(
      child: Container(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: RaisedButton(
            child: Text(
              "About app",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.red[200],
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(
                        "Esta app ha sido diseñada con la tecnología 'Flutter'. Entre los fallos conocidos es " +
                            "quizás la limitación impuesta por Google en el uso de la API con la que se obtienen " +
                            "los datos de youtube, la más notable. Esto puede causar que, eventualmente, se supere la cuota diaria " +
                            "y hasta el siguiente día no sea posible acceder a la información. Para evitar esto " +
                            "se ha diseñado un algoritmo que actualiza los datos cada 3 días; por lo que videos nuevos " +
                            "es posible no verlos hasta que el algoritmo vuelva a permitir la actualización. Cualquier " +
                            "fallo o 'bug' que se pueda localizar se agradecería su reporte a: valenreta.developer@gmail.com. Muchas gracias \n\n" +
                            "Version 0.0.1 (beta1)",
                      ),
                    );
                  });
            },
          ),
        ),
      ),
    );
  }

  Row _buildRotateText() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 25,
        ),
        Text(
          "Become    ",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        RotateAnimatedTextKit(
          isRepeatingAnimation: true,
          totalRepeatCount: 20,
          text: ["PATREON", "DIFFERENT", "PHYSIC"],
          textStyle: TextStyle(
              fontSize: 25,
              color: Colors.red[200],
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Center _buildTyperText() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: TyperAnimatedTextKit(
            speed: Duration(milliseconds: 100),
            textStyle: TextStyle(fontSize: 25),
            text: [
              "Si te gusta el contenido del canal, puedes apoyarme en PATREON.",
              "Para hacerlo, sólo tienes que pulsar sobre el icono de la parte superior.",
              "Muchas gracias. Nos ayudas a seguir creciendo."
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<PlayListModel>> _buildFutureBuilder() {
    return FutureBuilder(
      future: youtubeProvider.getPlaylist(),
      builder: (context, AsyncSnapshot<List<PlayListModel>> snapshot) {
        Widget returned;
        if (snapshot.hasError) {
          print(snapshot.error);
          return DataError();
        }
        if (!snapshot.hasData) {
          //TODO:
          returned = ProgressNoData();
        }
        if (snapshot.hasData) {
          List<PlayListModel> list = snapshot.data;
          returned = SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    "/videos",
                    arguments: [
                      list[index].id,
                      list[index].url,
                      list[index].title
                    ],
                  );
                },
                title: Text(list[index].title),
                leading: Hero(
                  tag: list[index].id,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(list[index].url),
                  ),
                ),
              );
            }, childCount: list.length),
          );
        }

        return CustomScrollView(
          slivers: <Widget>[
            _buildSliverAppBar(),
            _buildSliverToBoxAdapter(),
            returned,
          ],
        );
      },
    );
  }

  SliverToBoxAdapter _buildSliverToBoxAdapter() {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Text(
            "Listas de Reproducción",
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      forceElevated: true,
      expandedHeight: 150,
      pinned: true,
      backgroundColor: Colors.black,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.all(8),
        collapseMode: CollapseMode.none,
        background: Image.network(
          "https://image.freepik.com/foto-gratis/pizarra-inscrita-formulas-calculos-cientificos_1150-19413.jpg",
          fit: BoxFit.cover,
        ),
        centerTitle: true,
        title: CircularProfileAvatar(
          "https://yt3.ggpht.com/a/AATXAJyTgUDGtmorZrHET7NO0YdRf3HLJMM7iZ6C1Q=s288-c-k-c0xffffffff-no-rj-mo",
          borderColor: Colors.red,
          borderWidth: 3,
        ),
      ),
    );
  }
}



