import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(title: "Contador de Fucking Pessoas", home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _peoople = 5;

  void changePeoople(int aValue) {
    setState(() {
      _peoople += aValue;
    });
  }

  String getEstadoRestaurant() {
    if (_peoople > 10)
      return "FULL..SAI FORA";
    else if (_peoople >= 0)
      return "TA SAFE..PODE VIM";
    else
      return "Ta errado Mané";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          'images/restaurant.jpg',
          fit: BoxFit.cover,
          height: 1000.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Pessoas: $_peoople",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(10),
                  child: FlatButton(
                    child: Text(
                      "+1",
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    ),
                    onPressed: () {
                      changePeoople(1);
                    },
                  )),
              Padding(
                padding: EdgeInsets.all(10),
                child: FlatButton(
                  child: Text(
                    "-1",
                    style: TextStyle(fontSize: 40.0, color: Colors.white),
                  ),
                  onPressed: () {
                    changePeoople(-1);
                  },
                ),
              )
            ]),
            Text(
              getEstadoRestaurant(),
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontSize: 30.0),
            )
          ],
        ),
      ],
    );
  }
}
