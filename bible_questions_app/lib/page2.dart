import 'dart:html';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

Future<Intrebare> fetchAlbum() async {
  final response =
      await http.get(Uri.parse('https://proiect.sanvois.ro/database.php'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Intrebare.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Intrebare {
  final int id;
  final String text;
  final String imagine;
  final int raspunsCorect;
  final String popUp;

  Intrebare(
      {required this.id,
      required this.text,
      required this.imagine,
      required this.raspunsCorect,
      required this.popUp});

  factory Intrebare.fromJson(Map<String, dynamic> json) {
    var _intrebari = [];
    //foreach
    return Intrebare(
      id: json['id'],
      text: json['text'],
      imagine: json['imagine'],
      raspunsCorect: json['raspunsCorect'],
      popUp: json['popUp'],
    );
  }
}

class Page2 extends StatefulWidget {
  /*Page2({
    Key key,
    this.title,
  }) : super(key: key);*/

  //final String title;

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  late Future<Intrebare> futureAlbum;

  @override
  void initState() {
    super.initState();
    //futureAlbum = fetchAlbum();
    //print(futureAlbum);

    //_fetchIntrebari();
  }

  int _intrebare = 0;
  var _btn1Color = MaterialStateProperty.all(Colors.grey[400]);
  var _btn2Color = MaterialStateProperty.all(Colors.grey[400]);
  var _popColor = Colors.white;
  var _isDisabled = true;
  var _answered = false;

  var intrebari = [
    Intrebare(
      id: 1,
      text: "text",
      imagine: "assets/images/bg_q/rut.jpg",
      raspunsCorect: 1,
      popUp: "popup",
    ),
  ];

  Future<void> _fetchIntrebari() async {
    final response =
        await http.get(Uri.parse("https://proiect.sanvois.ro/database.php"));
    final data = [
      Intrebare.fromJson(json.decode(response.body)),
    ];

    setState(() {
      print(intrebari);
      intrebari = data;
      print(intrebari);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Column(
            children: [
              Image.asset(intrebari[_intrebare].imagine),
              SizedBox(
                height: 25,
              ),
              Text(
                intrebari[_intrebare].text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: ButtonBar(
                  mainAxisSize: MainAxisSize
                      .min, // this will take space as minimum as posible(to center)
                  children: <Widget>[
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: _btn1Color,
                        textStyle: MaterialStateProperty.all(TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                      ),
                      child: Text('ADEVARAT'),
                      onPressed: _answered
                          ? null
                          : () => setState(() {
                                _answered = true;
                                _isDisabled = false;
                                if (intrebari[_intrebare].raspunsCorect == 1) {
                                  _btn1Color = MaterialStateProperty.all(
                                      Colors.green[400]);
                                  _popColor = Colors.green.shade700;
                                } else {
                                  _btn1Color = MaterialStateProperty.all(
                                      Colors.red[400]);
                                  _popColor = Colors.red.shade700;
                                }
                              }),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: _btn2Color,
                        textStyle: MaterialStateProperty.all(TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                      ),
                      child: Text('FALS'),
                      onPressed: _answered
                          ? null
                          : () => setState(() {
                                _answered = true;
                                _isDisabled = false;
                                if (intrebari[_intrebare].raspunsCorect == 2) {
                                  _btn2Color = MaterialStateProperty.all(
                                      Colors.green[400]);
                                  _popColor = Colors.green.shade700;
                                } else {
                                  _btn2Color = MaterialStateProperty.all(
                                      Colors.red[400]);
                                  _popColor = Colors.red.shade700;
                                }
                              }),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 80,
              ),
              ElevatedButton(
                child: Text('VERIFICA'),
                onPressed: _isDisabled
                    ? null
                    : () {
                        _isDisabled = false;
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 150,
                              color: Colors.white,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      intrebari[_intrebare].popUp,
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                        color: _popColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                      onPressed: () => setState(() {
                                        print("urmatoarea intrebare");
                                        _intrebare += 1;
                                        _btn1Color = MaterialStateProperty.all(
                                            Colors.grey[400]);
                                        _btn2Color = MaterialStateProperty.all(
                                            Colors.grey[400]);
                                        _isDisabled = true;
                                        _answered = false;
                                        Navigator.pop(context);
                                      }),
                                      child: Text('Urmatoarea intrebare'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
