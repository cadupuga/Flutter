import 'dart:io';

import 'package:agenda_de_contatos/Helpers/contactHelper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact> _contacts = List();

  ContactHelper contactHelper = ContactHelper();

  @override
  void initState() {
    super.initState();

    setState(() {
      contactHelper.getAllContacts().then((list) {
        _contacts = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Contatos'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 10),
        itemCount: _contacts.length,
        itemBuilder: ((context, index) {
          return _cardBuilder(context, index);
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  Widget _cardBuilder(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _contacts[index].img != null
                            ? FileImage(File(_contacts[index].img))
                            : AssetImage('images/person.png'))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _contacts[index].name,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _contacts[index].phone,
                      style:
                          TextStyle(fontSize: 22),
                    ),
                    Text(
                      _contacts[index].email,
                      style:
                          TextStyle(fontSize: 22)
                          )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
