import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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
  List _todoList = [];
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  final TextEditingController _tarefaControler = TextEditingController();

  @override
  void initState() {
    super.initState();
    _readData().then((data) {
      setState(() {
        _todoList = jsonDecode(data);
      });
    });
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo['title'] = _tarefaControler.text;
      newToDo['ok'] = false;
      _tarefaControler.text = '';
      _todoList.add(newToDo);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Lista de Tarefas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  controller: _tarefaControler,
                  decoration: InputDecoration(
                      labelText: 'Nova Tarefa',
                      labelStyle: TextStyle(color: Colors.deepPurple)),
                )),
                RaisedButton(
                  color: Colors.deepPurple,
                  child: Text('ADD', style: TextStyle(color: Colors.white)),
                  textColor: Colors.deepPurple,
                  onPressed: _addToDo,
                )
              ],
            ),
          ),
          Expanded(
              child: RefreshIndicator(
                  onRefresh: _refreshIndicator,
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10.0),
                    itemCount: _todoList.length,
                    itemBuilder: _itemBuielder,
                  )))
        ],
      ),
    );
  }

  Widget _itemBuielder(context, index) {
    return Dismissible(
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_todoList[index]);
          _lastRemovedPos = index;
          _todoList.removeAt(index);
          _saveData();

          final snack = SnackBar(
            content: Text(
              'Tarefa ${_lastRemoved['title']} removida!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            duration: Duration(seconds: 4),
            backgroundColor: Colors.deepPurpleAccent,
            action: SnackBarAction(
              label: 'Desfazer',
              textColor: Colors.white,
              onPressed: () {
                setState(() {
                  _todoList.insert(_lastRemovedPos, _lastRemoved);
                  _saveData();
                });
              },
            ),
          );

          Scaffold.of(context).showSnackBar(snack);
        });
      },
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      child: CheckboxListTile(
        title: Text(_todoList[index]['title']),
        value: _todoList[index]['ok'],
        onChanged: (c) {
          setState(() {
            _todoList[index]['ok'] = c;
            _saveData();
          });
        },
        secondary: CircleAvatar(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          child: Icon(_todoList[index]['ok'] ? Icons.check : Icons.error),
        ),
      ),
      background: Container(
        color: Colors.deepPurple,
        child: Align(
          alignment: Alignment(0.9, 0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      direction: DismissDirection.startToEnd,
    );
  }

  Future<Null> _refreshIndicator() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _todoList.sort((a, b) {
        if (a['ok'] && !b['ok'])
          return 1;
        else if (!a['ok'] && b['ok'])
          return -1;
        else
          return 0;
      });

      _saveData();
    });

    return null;
  }

  Future<File> _getFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_todoList);
    final file = await _getFiles();

    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFiles();

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
