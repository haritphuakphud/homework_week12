import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homework_week12/page/home/home_page.dart';
import 'package:http/http.dart' as http;

class loginPage extends StatefulWidget {
  loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  String _inputPassword = '';
  static const _PIN = '123456';
  double buttonSize = 75.0;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              //color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock,
                        size: 125.0,
                        color: Colors.redAccent,
                      ),
                    ],
                  ),

                  Text('LOGIN', style: TextStyle(color: Colors.yellow, fontSize: 40.0),),

                ],
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for(var i = 0; i < 6; i++) buildPassCode(i: i),
            ],
          ),

          Container(
            //color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for(var i = 1; i <= 3; i++) buildButton(num: i),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for(var i = 4; i <= 6; i++) buildButton(num: i),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for(var i = 7; i <= 9; i++) buildButton(num: i),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: buttonSize,
                        width: buttonSize,

                      ),
                    ),
                    buildButton(num: 0),
                    buildButton(num: -1),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                      child: TextButton(
                        onPressed: () {

                        },
                        child: Text('Forget Password', style: TextStyle(fontSize: 20.0, color: Colors.yellow),),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );

  }

  Widget buildButton({int? num}) {

    Widget? child;
    BoxDecoration? boxDecoration;

    if(num == -1) {
      child = Icon(Icons.backspace, size: 30.0, color: Colors.white,);
    }
    else {
      child = Text('${num}', style: TextStyle(fontSize: 20.0, color: Colors.black),);
      boxDecoration = BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.0),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            if (num != -1 && _inputPassword.length != 6) {
              _inputPassword += '$num';
            }
            else if (num == -1)
              _inputPassword = _inputPassword.substring(0, _inputPassword.length - 1);
          });
          checkPin();
        },
        borderRadius: BorderRadius.circular(buttonSize/2),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: boxDecoration,
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }

  checkPin() async {
    if (_inputPassword.length == 6) {
      final url = Uri.parse("https://cpsu-test-api.herokuapp.com/login");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'pin': _inputPassword}),
      );

      var json = jsonDecode(response.body);
      if (json['data']) {
        setState(() {
          _inputPassword = "";
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        setState(() {
          _inputPassword = "";
        });
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.yellow,
                title: Row(
                  children: [
                    Text('Incorrect PIN'),
                  ],
                ),
                content: Text('Please try again'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Ok', style: TextStyle(color: Colors.black))),
                ],
              );
            });
      }
    }
  }

  Widget buildPassCode({int? i}) {
    BoxDecoration? blankPIN = BoxDecoration(
      shape: BoxShape.rectangle,
      color: Colors.deepPurple.withOpacity(0.5),
      border: Border.all(color: Colors.black, width: 0.5),
    );


    BoxDecoration? fillPIN = BoxDecoration(
      shape: BoxShape.rectangle,
      color: Colors.yellow,
      border: Border.all(color: Colors.green, width: 2.0),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0, left: 10.0, right: 10.0),
      child: Container(
        width: 20.0,
        height: 20.0,
        decoration: (i! < _inputPassword.length) ? fillPIN : blankPIN,
      ),
    );
  }
}
