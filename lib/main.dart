import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=5be23b20";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.amber),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text) {
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("\$ Conversor \$"),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshop) {
            switch (snapshop.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando dados....",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshop.hasError) {
                  return Center(
                    child: Text(
                      "Carregando dados....",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                this.dolar = snapshop.data["results"]["currencies"]["USD"]["buy"];
                this.euro = snapshop.data["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on,
                          size: 150.0, color: Colors.amber),
                      buildtextField(
                          "Reais", "R\$ ", realController, _realChanged),
                      Divider(),
                      buildtextField(
                          "Dólares", "US\$ ", dolarController, _dolarChanged),
                      Divider(),
                      buildtextField(
                          "Euros", "€ ", euroController, _euroChanged),
                    ],
                  ),
                );
            }
          },
        ));
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

Widget buildtextField(String label, String prefix,
        TextEditingController controller, Function fn) =>
    TextField(
      style: TextStyle(color: Colors.amber),
      controller: controller,
      decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          labelText: label,
          labelStyle: TextStyle(color: Colors.amber),
          prefixText: prefix),
      onChanged: fn,
      keyboardType: TextInputType.number,
    );
