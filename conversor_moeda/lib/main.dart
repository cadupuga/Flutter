import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?key=9cfe541e';

void main() async {
  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(
          hintColor: Colors.amber,
          primaryColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber))))));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return jsonDecode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;

  TextEditingController controlerReal = TextEditingController();
  TextEditingController controlerDolar = TextEditingController();
  TextEditingController controlerEuro = TextEditingController();

  void _realChanged(String text) {
    double reais = double.parse(text);
    controlerDolar.text = (reais / dolar).toStringAsFixed(2);
    controlerEuro.text  = (reais / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    double dolar = double.parse(text);
    controlerReal.text = (dolar * this.dolar).toStringAsFixed(2);
    controlerEuro.text  = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euro = double.parse(text);
    controlerDolar.text = (euro * this.euro / dolar).toStringAsFixed(2);
    controlerReal.text  = (euro * this.euro).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text('Convesor de Moedas'),
          centerTitle: true),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text('Carregando Dados'),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text('Carregando Dados'),
                );
              } else {
                dolar = snapshot.data['results']['currencies']['USD']['buy'];
                euro = snapshot.data['results']['currencies']['EUR']['buy'];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on,
                          size: 150, color: Colors.amber),
                      buielderTextField('Reais', 'R\$', controlerReal, _realChanged),
                      Divider(),
                      buielderTextField('Dólar', 'US\$', controlerDolar, _dolarChanged),
                      Divider(),
                      buielderTextField('Euro', '€', controlerEuro, _euroChanged)
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buielderTextField(
    String labelText, String prefix, TextEditingController controler, Function functionChanged) {
  return TextField(
    controller: controler,
    onChanged: functionChanged,
    decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.amber),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25),
    keyboardType: TextInputType.number,
  );
}
