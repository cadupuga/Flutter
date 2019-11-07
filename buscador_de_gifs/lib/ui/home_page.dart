import 'dart:convert';
import 'package:buscador_de_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:vibration/vibration.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offSet = 0;

  final TextEditingController searchController = TextEditingController();

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == '') {
      response = await http.get(
          'https://api.giphy.com/v1/gifs/trending?api_key=qd6OOyItMFJiZFSm0Fh21poL6H43RMFv&limit=20&rating=G');
    } else {
      response = await http.get(
          'https://api.giphy.com/v1/gifs/search?api_key=qd6OOyItMFJiZFSm0Fh21poL6H43RMFv&q=$_search&limit=19&offset=$_offSet&rating=G&lang=en');
    }
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.network(
            'https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif'),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              controller: searchController,
              onSubmitted: (text) {
                setState(() {
                  _search = searchController.text;
                });
              },
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Busca',
                labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      alignment: Alignment.center,
                      width: 200.0,
                      height: 200.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createGifsTable(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _createGifsTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 3, mainAxisSpacing: 3),
      itemCount: _getCountList(snapshot.data['data']),
      itemBuilder: (context, index) {
        if ((_search == '') || (index < snapshot.data['data'].length)) {
          return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GifPage(snapshot.data['data'][index])));
              },
              onLongPress: () {
                if (Vibration.hasVibrator() != null){ 
                  Vibration.vibrate(duration: 50, amplitude: 128);
              }
                Share.share(snapshot.data['data'][index]['images']
                    ['fixed_height']['url']);
              },
              /*Image.network(
                snapshot.data['data'][index]['images']['fixed_height']['url'],
                height: 300,
                fit: BoxFit.cover),*/
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data['data'][index]['images']['fixed_height']
                    ['url'],
                fit: BoxFit.cover,
                height: 300.0,
              ));
        } else {
          return Container(
              alignment: Alignment.center,
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.white, size: 50),
                    Text(
                      'Carregar mais..',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    _offSet += 19;
                  });
                },
              ));
        }
      },
    );
  }

  int _getCountList(List data) {
    if (_search == '')
      return data.length;
    else
      return data.length + 1;
  }
}
