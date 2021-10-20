import 'dart:html';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class Intrebare {
  final int id;
  final String text;
  final String image;
  final int raspunsCorect;
  final String popUp;

  Intrebare(this.id, this.text, this.image, this.raspunsCorect, this.popUp);
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
  final intrebari = [
    Intrebare(
        1,
        'Adevarat sau fals? Aron era cu trei ani mai mare decat Moise. (Exodul 7:7)',
        'assets/images/bg_q/aron.jpg',
        1,
        'Adevarat'), //aici trecem raspunsul corect, 1 butonul 1, 2 = butonul 2 s.a.m.d, in cazul nostru 1=adevarat, 2=fasls
    Intrebare(
        2,
        'Adevarat sau fals? Saul a fost un om lipsit de vigoare. (2 Samuel 1:23)',
        'assets/images/bg_q/saul.jpg',
        2,
        'Saul a fost asemanat cu acvilele iuti si cu leii puternici.'),
    Intrebare(
        3,
        'Adevarat sau fals? Samuel a fost singurul copil al Anei. (1 Samuel 2:21)',
        'assets/images/bg_q/ana.jpg',
        2,
        'Mai taziu, Ana a avut inca trei fii si doua fiice.'),
    Intrebare(
        4,
        'Adevarat sau fals? Manoah a pregatit o masa pentru inger. (Judecatorii 13:15, 16, 19)',
        'assets/images/bg_q/manoah.jpg',
        2,
        'El i-a oferit o ofranda arsa lui Iehova.'),
    Intrebare(
        5,
        'Adevarat sau fals? Ghedeon a refuzat sa guvereneze peste Israel. (Judecatorii 8:22, 23)',
        'assets/images/bg_q/ghedeon.jpg',
        1,
        'Adevarat'),
    Intrebare(6, 'Adevarat sau fals? Naomi s-a casatorit cu Boaz. (Rut 14:3)',
        'assets/images/bg_q/naomi.jpg', 2, 'Rut s-a casatorit cu Boaz.'),
    Intrebare(
        7,
        'Adevarat sau fals? Rahav a fost stra-strabunica regelui David',
        'assets/images/bg_q/rahav.jpg',
        1,
        'Adevarat'),
    Intrebare(
        8,
        'Adevarat sau fals? Asemenea tatalui lor, fii lui Core s-au razvratit impotriva lui Moise si a lui Aron si au murit impreuna cu Core (Numerele 26:10, 11)',
        'assets/images/bg_q/core.jpg',
        2,
        'Fals'),
    Intrebare(
        9,
        'Adevarat sau fals? Tatal Seforei era preot (Exodul 2:16, 21).',
        'assets/images/bg_q/sefora.jpg',
        1,
        'Adevarat'),

    Intrebare(
        10,
        'Adevarat sau fals? Faraonul a fost un om umil(Exodul 14:19, 20)',
        'assets/images/bg_q/faraonul.jpg',
        2,
        'Faraonul s-a purtat cu trufie.'),
  ];

  int _intrebare = 0;
  var _btn1Color = MaterialStateProperty.all(Colors.grey[400]);
  var _btn2Color = MaterialStateProperty.all(Colors.grey[400]);
  var _popColor = Colors.white;
  var _isDisabled = true;
  var _answered = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Column(
            children: [
              Image.asset(intrebari[_intrebare].image),
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
