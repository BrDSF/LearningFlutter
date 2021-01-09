import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //permite aquisições via api
import 'dart:async'; //biblioteca usada para requisições assícronas, não há necessidade de esperar.
import 'dart:convert';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=47a5af8f";

void main() async {
  print(await getData());
  runApp(MaterialApp(
    title: "Conversor de Moedas",
    home: Home(),
  ));
}

Future<Map> getData() async {
  //a api retorna um dado do futuro
  http.Response response = await http.get(request); //await espera o dado chegar
  return json
      .decode(response.body); //pega um arquivo json e transforma em um mapa
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$Conversor de Moeda\$"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) { //snapshot vê o estado da conexão
            switch (snapshot.connectionState) {
              case ConnectionState.none:  //caso não esteja conectado
              case ConnectionState.waiting: //₢aso esteja esperando os dados
                return Center(
                  child: Text(
                    "Carregando Dados...",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) { //caso aja algum erro na conexão 
                  return Center(
                    child: Text(
                      "Erro ao Carregar Dados :(",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                }else{
                  return Container(
                    color: Colors.green,
                  );
                }              
            }
          }
      ),
    );
  }
}
