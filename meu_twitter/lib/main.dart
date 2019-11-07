import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlue),
              child: Text(
                "Teste",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: Text(
          "Meu Twitter",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          Icon(Icons.refresh),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 25,
        showSelectedLabels: false,
        fixedColor: Colors.lightBlue,
        backgroundColor: Colors.deepOrange,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                //color: Colors.white,                
              ),
              title: Text('')),
          BottomNavigationBarItem(
              title: Text(''),
              icon: Icon(
                Icons.security,
                //color: Colors.white,
              ))
        ],
      ),
    );
  }
}
