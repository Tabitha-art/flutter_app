//import 'dart:html';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

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

  factory Intrebare.fromJson(Map<dynamic, dynamic> js) {
    // fiecare proprietate din js este de tip String
    return Intrebare(
      id: int.parse(js['id']), // conversie in int deoarece noua ne vine String
      text: js['intrebare'],
      imagine: js['imagine'].toString().replaceFirst('flutter_app', 'assets'),
      raspunsCorect: int.parse(js['raspunsCorect']),
      popUp: js['popUp'],
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
    _fetchIntrebari();
    intrebari2 =
        _fetchIntrebari2(); // deoarece FutureBuilder "urmareste" modificarea variabilei
    // putem sa ii schimbam valoarea oricand
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

  // varianta cu future unde variabila este initializata fara valoare
  late Future<List<Intrebare>> intrebari2;
  Future<List<Intrebare>> _fetchIntrebari2() async {
    final response2 =
        await http.get(Uri.parse("https://proiect.sanvois.ro/database.php"));

    final data2 = List<Intrebare>.from(
        json.decode(response2.body).map((i) => Intrebare.fromJson(i)));

    return data2;
  }

  Future<void> _fetchIntrebari() async {
    final response =
        await http.get(Uri.parse("https://proiect.sanvois.ro/database.php"));

    // List<Intrebare>.from -- creeaza o lista din ..
    // json.decode(response.body) -- raspunsul convertit in format JSON
    // .map((i) => Intrebare.fromJson(i)) -- creeaza perechi de cheie-valoare(array)
    // (i) => Intrebare.fromJson(i) -- la fiecare element din array se aplica functia Intrebare.fromJson
    // fromJson -- primeste ca date de intrare un array de proprietati in cazul nostru
    // si returneaza un obiect de tip Intrebare cu acele proprietati
    // intr-un final .map returneaza un array de obiecte de tip Intrebare care sunt transformate in List-a
    final data = List<Intrebare>.from(
        json.decode(response.body).map((i) => Intrebare.fromJson(i)));

    // deoarece variabila intrebari este deja initializata si folosita in proiect
    // trebuie folosit setState pentru a notifica sistemul ca variabila a fost modificata
    setState(() {
      intrebari = data;
    });
  }

  // widget de test
  // pt aplicatii mai complexe, ca sa nu ajungi sa ai o gramada de elemente bagate unul in altul
  // poti defini un Widget care se ocupa de afisarea unei portiuni din tot continutul paginii
  //
  Widget popUp(BuildContext context) {
    return Row(
      children: [
        Text('1'),
        Text('2'),
      ],
    );
  }

  // showModalBottomSheet am incapsulato intr-o functie pe care o apelez cu variabila "context" necesara
  // pentru a o putea scoate din widget
  // acest widget poate fii pus intr-un alt fisier si importat pentru a face codul mai lizibil
  void _showPopUp(BuildContext context) {
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
                    _btn1Color = MaterialStateProperty.all(Colors.grey[400]);
                    _btn2Color = MaterialStateProperty.all(Colors.grey[400]);
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Column(
            children: [
              FutureBuilder<List<Intrebare>>(
                // definim tipul de date pe care il v-om folosii
                future: intrebari2, // variabila care va transmite valori
                builder: (context, snapshot) {
                  // snapshot este un obiect de tip future
                  if (snapshot.hasData) {
                    //snapshot.data contine variabila intrebari2
                    return Column(
                      children: [
                        popUp(
                            context), // aici va fii afisat widgetul custom facut de mine
                        Text(snapshot.data!.first.text),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                        '${snapshot.error}'); // iar aici returnezi ecranul cand nu poti prelua date
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator(); // asta este afisat atat timp cat inca nu au fost primite datele
                },
              ),
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
                        _showPopUp(context);
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
