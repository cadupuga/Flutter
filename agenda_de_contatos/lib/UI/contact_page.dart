import 'dart:io';

import 'package:agenda_de_contatos/Helpers/contactHelper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _contactEdit;
  bool _userEdting = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _contactEdit = Contact();
    } else {
      _contactEdit = Contact.fromMap(widget.contact.topMap());
      _nameController.text = _contactEdit.name;
      _phoneController.text = _contactEdit.phone;
      _emailController.text = _contactEdit.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text(_contactEdit.name ?? 'Novo Contato'),
            backgroundColor: Colors.red,
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context, _contactEdit);
            },
            backgroundColor: Colors.red,
            child: Icon(Icons.save),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      ImagePicker.pickImage(source: ImageSource.gallery)
                          .then((file) {
                        setState(() {
                          if (file.path != null) {
                            _contactEdit.img = file.path;
                          }
                        });
                      });
                    },
                    child: Container(
                      height: 180,
                      width: 180,
                      padding: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _contactEdit.img != null
                                  ? FileImage(File(_contactEdit.img))
                                  : AssetImage('images/person.png'))),
                    )),
                TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    onChanged: (text) {
                      setState(() {
                        _contactEdit.name = text;
                        _userEdting = true;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: 'Nome',
                        labelStyle: TextStyle(color: Colors.red))),
                TextField(
                    controller: _phoneController,
                    onChanged: (text) {
                      _contactEdit.phone = text;
                      _userEdting = true;
                    },
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        labelText: 'Telefone',
                        labelStyle: TextStyle(color: Colors.red))),
                TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (text) {
                      _contactEdit.email = text;
                      _userEdting = true;
                    },
                    decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.red)))
              ],
            ),
          )),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdting) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Descartar alterações ?'),
              content: Text('Se sair as alterações serão perdidas.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
