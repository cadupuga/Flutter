import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {
  final Map gif;

  GifPage(this.gif);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(gif['title']),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            color: Colors.white,
            onPressed: (){
              Share.share(gif['images']['fixed_height']['url']);
            },
          )
        ],
      ),
      body: Center(
        child: Image.network(gif['images']['fixed_height']['url'], fit: BoxFit.cover,),
      ),
      
    );
  }
}