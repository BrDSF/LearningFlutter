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
  final _toDoControler = TextEditingController();

  List _toDoList = [];
  //mapa que salva o ultimo item removido
  Map<String, dynamic> _lastRemoved;
  //posição do ultimo item removido
  int _lastRemovedPos;

  @override
  void initState() {
    super.initState();
    _readData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas "),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                /*expanded determina um tamanho, pois os widgets
                não sabem o tamamnho que devem ocupar na tela*/
                Expanded(
                  child: TextField(
                    controller: _toDoControler,
                    decoration: InputDecoration(
                        labelText: "Nova Tarefa",
                        labelStyle: TextStyle(
                          color: Colors.blueAccent,
                        )),
                  ),
                ),
                RaisedButton(
                    color: Colors.blueAccent,
                    child: Text("ADD"),
                    textColor: Colors.white,
                    onPressed: _addToDo)
              ],
            ),
          ),
          Expanded(
              child: RefreshIndicator(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                //pega o tamanho da lista
                itemCount: _toDoList.length,
                //context é o conteúdo, index  o id da lista
                itemBuilder: buildItem),
            onRefresh: _refresh,
          )),
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_toDoList[index]["title"]),
        value: _toDoList[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(_toDoList[index]["ok"] ? Icons.check : Icons.error),
        ),
        onChanged: (c) {
          setState(() {
            _toDoList[index]["ok"] = true;
            _saveData();
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_toDoList[index]);
          _lastRemovedPos = index;
          _toDoList.removeAt(index);

          _saveData();
          // cria um snackbar para remover o item; 
          final snackBar = SnackBar(
              content: Text("Tarefa \"${_lastRemoved["title"]}\" removida"),
              action: SnackBarAction(
                  label: "Desfazer",
                  onPressed: () {
                    setState(() {
                      _toDoList.insert(_lastRemovedPos, _lastRemoved);
                      _saveData();
                    });
                  }),
              duration: Duration(seconds: 2));
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snackBar);
        });
      },
    );
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoControler.text;
      _toDoControler.text = "";
      newToDo["ok"] = false;
      _toDoList.add(newToDo);
      _saveData();
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _toDoList.sort((a, b) {
        if (a["ok"] && !b["ok"])
          return 1;
        else if (!a["ok"] && b["ok"])
          return -1;
        else
          return 0;
      });
      _saveData();
    });
    return null;
  }

  /*essa função cria no diretório do celular o arquivo data.json
  e retorna ele*/
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  /*essa função salva os dados no lista.json do _getData
   primeiro ele tranforma a lista em json, e depois escreve no arquivo */
  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
