import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('RUT'),
          backgroundColor: Colors.purple[800],
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_q/rut.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Completati spatiile libere. Rut s-a casatorit cu _____ si a devenit o ascendenta a lui _____ si a lui ______.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white24),
                        textStyle:
                            MaterialStateProperty.all(TextStyle(fontSize: 35))),
                    onPressed: () {},
                    child: Text('VERIFICA'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
