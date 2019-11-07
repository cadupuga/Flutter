import 'dart:io';

import 'package:agenda_de_contatos/Helpers/contactHelper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  
  Contact _contactEdit;
  bool _userEdting = false;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _contactEdit = Contact();
    } else {
      _contactEdit = Contact.fromMap(widget.contact.topMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_contactEdit.name ?? 'Novo Contato'),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.red,
          child: Icon(Icons.save),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                onTap: (){},
                  child: Container(
                height: 180,
                width: 180,
                padding: EdgeInsets.only(top: 0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _contactEdit.img != null
                            ? FileImage(File(_contactEdit.img))
                            : AssetImage('images/person.png'))),
              )),
              TextField(
                  keyboardType: TextInputType.text,
                  onChanged: (text){
                    setState(() {
                       _contactEdit.name = text;
                       _userEdting = true;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'Nome',
                      labelStyle: TextStyle(color: Colors.red))),
              TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      labelText: 'Telefone',
                      labelStyle: TextStyle(color: Colors.red))),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.red)))
            ],
          ),
        ));
  }
}
