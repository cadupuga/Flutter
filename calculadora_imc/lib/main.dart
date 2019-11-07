import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController controladorPeso = TextEditingController();
  TextEditingController controladorAltura = TextEditingController();
  double _imc = 0;

  void _resetFields() {
    setState(() {
      controladorAltura.text = '';
      controladorPeso.text = '';
      _imc = 0;
      _formKey = GlobalKey<FormState>(); 
    });
  }

  String getInfo() {
    String infoText = '';

    if (_imc < 18.6 && _imc > 0) {
      infoText = 'Abaixo do Peso ${_imc.toStringAsPrecision(4)}';
    } else if (_imc >= 18.6 && _imc < 24.9) {
      infoText = 'Peso Ideal ${_imc.toStringAsPrecision(4)}';
    } else if (_imc >= 24.9 && _imc < 29.9) {
      infoText = 'Levemente acima do Peso ${_imc.toStringAsPrecision(4)}';
    } else if (_imc >= 29.9 && _imc < 34.9) {
      infoText = 'Obesidade Grau I ${_imc.toStringAsPrecision(4)}';
    } else if (_imc >= 34.9 && _imc < 39.9) {
      infoText = 'Obesidade Grau II ${_imc.toStringAsPrecision(4)}';
    } else if (_imc >= 40) {
      infoText = 'Obesidade Grau III ${_imc.toStringAsPrecision(4)}';
    }
    return infoText;
  }

  void doCalc() {
    setState(() {
      double peso = double.parse(controladorPeso.text);
      double altura = double.parse(controladorAltura.text) / 100;
      _imc = peso / (altura * altura);
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("Calculadora de IMC",
              style:
                  TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _resetFields,
            )
          ],
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(
                    Icons.person_outline,
                    size: 120,
                    color: Colors.green,
                  ),
                  TextFormField(
                    controller: controladorPeso,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Insira seu Peso';
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Peso (Kg)',
                        labelStyle: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                    ),
                  ),
                  TextFormField(
                    controller: controladorAltura,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Altura (cm)',
                        labelStyle: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Insira sua Altura';
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Container(
                      height: 50,
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            doCalc();
                          }
                        },
                        child: Text("Calcular",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Text(getInfo(),
                      style: TextStyle(color: Colors.green, fontSize: 20),
                      textAlign: TextAlign.center)
                ],
              ),
            )));
  }
}
