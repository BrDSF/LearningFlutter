import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //permite aquisições via api
import 'package:async/async.dart'; //biblioteca usada para requisições assícronas, não há necessidade de esperar.
import 'dart:convert';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=47a5af8f"; //api

void main() async {
  http.Response response = await http.get(
      request); //await para esperar a resposta da api, logo a main deve ter async
  print(json.decode(response.body)["results"]);
  runApp(MaterialApp(
    title: "Conversor de Moedas",
    home: Container(),
  ));
}
