import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "Imc Calculator",
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  String _infoText = "Informe seus dados!";
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /* this funtion just reset the fields for the user, it's called in the refresh
  button */
  void _resetField() {
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _infoText = "Informe seus dados!";
      _formKey = GlobalKey<FormState>();
    });
  }

  /* this function change  */
  void _calculate() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text);
      if (height <= 0.3 || weight <= 20.0) {
        _infoText = "Valores informados não são aceitos, digite novamente";
      } else {
        double imc = weight / (height * height);
        if (imc < 18.6) {
          _infoText =
              "Abaixo do Peso, seu IMC é: (${imc.toStringAsPrecision(3)})";
        } else if (imc >= 18.6 && imc < 24.9) {
          _infoText = "Peso Ideal seu IMC é: (${imc.toStringAsPrecision(3)})";
        } else if (imc >= 24.9 && imc < 29.9) {
          _infoText =
              "Levemente Acima do Peso seu IMC é: (${imc.toStringAsPrecision(3)})";
        } else if (imc >= 29.9 && imc < 34.9) {
          _infoText =
              "Obersidade Grau I seu IMC é: (${imc.toStringAsPrecision(3)})";
        } else if (imc >= 34.9 && imc < 39.9) {
          _infoText =
              "Obersidade Grau II seu IMC é: (${imc.toStringAsPrecision(3)})";
        } else if (imc > 39.9) {
          _infoText =
              "Obersidade Grau III seu IMC é: (${imc.toStringAsPrecision(3)})";
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calculadora de IMC"),
          centerTitle: true,
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh), onPressed: _resetField)
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(Icons.person_outline, size: 120.0, color: Colors.green),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Peso (kg)",
                      labelStyle:
                          TextStyle(color: Colors.green, fontSize: 25.0)),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 25.0,
                  ),
                  controller: weightController,
                  // ignore: missing_return
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Insira seu peso!";
                    }
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Altura (m)",
                    labelStyle: TextStyle(color: Colors.green, fontSize: 25.0),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 25.0,
                  ),
                  controller: heightController,
                  // ignore: missing_return
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Insira sua Altura!";
                    }
                  },
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Container(
                      height: 50.0,
                      child: RaisedButton(
                        child: Text("Calcular",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0)),
                        color: Colors.green,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            // ignore: unnecessary_statements
                            _calculate;
                          }
                        },
                      ),
                    )),
                Text(
                  _infoText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 25.0),
                )
              ],
            ),
          ),
        ));
  }
}
