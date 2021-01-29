import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;

  Future<Map> _getGif() async {
    http.Response response;

    //caso não tenha pesquisa em gif específico retorna os melhores.
    if (_search == null)
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=3bW9zmnhv4RVobmDbwctvOlsVyXfD6WA&limit=20&rating=g");
    else
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=3bW9zmnhv4RVobmDbwctvOlsVyXfD6WA&q=$_search&limit=19&&offset=$_offset&rating=g&lang=en");

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGif().then((map) {
      print(map);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise Aqui",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                });
              },
            ),
          ),
          //expanded ocupa apenas o espaço restante
          Expanded(
            child: FutureBuilder(
              future: _getGif(),
              builder: (context, snapshot) {
                //olha pro estado da conexão do snapshot
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      //indicador de carregando circular
                      child: CircularProgressIndicator(
                        //a cor da animação nunca vai mudar
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createGifTable(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    //view para mostrar widges em forma de grid
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
      itemCount: _getCount(snapshot.data["data"]),
      //constroi os gifs em cada grid
      itemBuilder: (context, index) {
        if (_search == null || index < snapshot.data["data"].length) {
          //Widget que ativa a possibilidade de clicar na imagem
          return GestureDetector(
            child: Image.network(
              snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300.0,
              fit: BoxFit.cover,
            ),
          );
        } else {
          return GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.add, color: Colors.white, size: 70.0),
                Text(
                  "Carregar mais...",
                  style: TextStyle(color: Colors.white, fontSize: 22.0),
                )
              ],
            ),
            onTap: () {
              setState(() {
                _offset += 19;
              });
            },
          );
        }
      },
    );
  }
}
