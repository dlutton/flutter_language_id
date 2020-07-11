import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_language_identification/flutter_language_identification.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLanguageIdentification languageIdentification;
  String _text;
  String _result = '';

  @override
  void initState() {
    super.initState();
    initLanguageIdentification();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initLanguageIdentification() async {
    languageIdentification = FlutterLanguageIdentification();

    languageIdentification.setSuccessHandler((message) {
      setState(() {
        print(message);
        _result = message;
      });
    });

    languageIdentification.setErrorHandler((message) {
      setState(() {
        print(message);
      });
    });

    languageIdentification.setFailedHandler((message) {
      setState(() {
        print(message);
        _result = message;
      });
    });
  }

  Future _identifyLanguage() async {
    if (_text != null && _text.isNotEmpty) {
      await languageIdentification.identifyLanguage(_text);
    }
  }

  void _onChange(String text) {
    setState(() {
      _text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('Flutter Language Identification'),
            ),
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: [
                  _inputSection(),
                  _btnSection(),
                  _resultSection()
                ]))));
  }

  Widget _resultSection() => Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(top: 100.0, left: 25.0, right: 25.0),
      child: Text(
        _result,
      ));

  Widget _inputSection() => Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
      child: TextField(
        onChanged: (String value) {
          _onChange(value);
        },
      ));

  Widget _btnSection() {
    return Container(
        padding: EdgeInsets.only(top: 50.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _buildButtonColumn(Colors.green, Colors.greenAccent,
              Icons.check_circle, 'Check', _identifyLanguage),
        ]));
  }

  Column _buildButtonColumn(Color color, Color splashColor, IconData icon,
      String label, Function func) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(icon),
              color: color,
              splashColor: splashColor,
              onPressed: () => func()),
          Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: Text(label,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: color)))
        ]);
  }
}
