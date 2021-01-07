import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(title: "Contador de Pessoas", home: Home()));
}

class Home extends StatefulWidget {
  @override
  _State createState() => _State();
}

//class that change the state of actual screen
class _State extends State<Home> {
  int _pessoas = 0;
  String _info = "Pode Entrar!";

  /*this function set the state of the variable _pessoas,
  thus, tells to build, to change the screen after a changed of _pessoas*/
  void _mudaTela(int delta) {
    setState(() {
      _pessoas += delta;
      if (_pessoas < 0) {
        _info = "Mundo invertido!";
      } else if (_pessoas <= 10) {
        _info = "Pode entrar!";
      } else {
        _info = "Lotado";
      }
    });
  }

  /* Widget that contains all the code for the counter of people */
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "images/restaurant.jpg",
          fit: BoxFit.cover,
          height: 1000.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Pessoas: $_pessoas",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text("+1",
                        style: TextStyle(fontSize: 40.0, color: Colors.white)),
                    onPressed: () {
                      _mudaTela(1);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text("-1",
                        style: TextStyle(fontSize: 40.0, color: Colors.white)),
                    onPressed: () {
                      _mudaTela(-1);
                    },
                  ),
                ),
              ],
            ),
            Text(
              "$_info",
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontSize: 30.0),
            )
          ],
        )
      ],
    );
  }
}
