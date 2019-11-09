import 'dart:io';

import 'package:agenda_de_contatos/Helpers/contactHelper.dart';
import 'package:agenda_de_contatos/UI/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

    _getAllContacts();
    
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
        onPressed: () {
          _goToContactPage();
        },
      ),
    );
  }

  Widget _cardBuilder(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _showOptions(context, index);
      },
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
                      fit: BoxFit.cover,
                        image: (_contacts[index].img != null &&
                                _contacts[index].img.isNotEmpty)
                            ? FileImage(File(_contacts[index].img))
                            : AssetImage('images/person.png'))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _contacts[index].name ?? '',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _contacts[index].phone ?? '',
                      style: TextStyle(fontSize: 22),
                    ),
                    Text(_contacts[index].email ?? '',
                        style: TextStyle(fontSize: 22))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _goToContactPage({Contact contact}) async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact)));

    if (recContact != null) {
      if (contact != null) {
        await contactHelper.updateContact(recContact);
      } else {
        await contactHelper.saveContact(recContact);
      }
    }

    _getAllContacts();
  }

  void _getAllContacts() {
    setState(() {
      contactHelper.getAllContacts().then((list) {
        _contacts = list;
      });
    });
  }

/*
  _deleteAllContacts() {
    contactHelper.deleteALLContact();
  }*/

  _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text(
                          'Ligar',
                          style: TextStyle(
                              color: Colors.red, 
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          launch('tel:${_contacts[index].phone}');
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text('Editar',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.pop(context);
                          _goToContactPage(contact: _contacts[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text('Excluir',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          contactHelper.deleteContact(_contacts[index].id);
                          setState(() {
                            _contacts.removeAt(index);
                          });
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }
}
