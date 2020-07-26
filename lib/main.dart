import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_beep/flutter_beep.dart';

void main(){
  runApp(MaterialApp(
    home:Home(),
  ));
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int repetition=4;
//  Timer pomodoro;
  int work=5;
  int rest=5;
  int _elapsed=0;
  int _netelapsed=0;
  bool _isStarted=false;
  List<String> progress=[];
  void startTimer(){
    _isStarted=true;
    _elapsed=0;
    _netelapsed=0;
    progress=[];
    Timer.periodic(Duration(seconds: 1), (timer) {

      setState((){
//        print("SetState executed");
        _elapsed++;
        _netelapsed++;
        if(_netelapsed>= repetition*(work+rest) ){
          print("Counter finished");
          _elapsed=0;
          _netelapsed=0;
          progress=[];
          timer.cancel();


        }
        else if(_elapsed>=work && ( progress.isEmpty || progress[progress.length-1]=='r' ) ){
          print("First else if printed");
          _elapsed-=work;
          progress.add("w");
          FlutterBeep.beep();
        }
        else if( progress.isNotEmpty && _elapsed>=rest && progress[progress.length-1]=='w' ){
          print("Second else if done");
          _elapsed-=rest;
          progress.add("r");
          FlutterBeep.beep();
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("=$progress"),

        ),
        body:Padding(
            padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      child:Text("-"),
                      onPressed:(){
                        if(!_isStarted){
                          setState(() {
                            repetition--;
                          });
                        }

                      } ,
                    ),
                    Text("Repetition=$repetition"),
                    RaisedButton(
                      child: Text("+"),
                      onPressed: (){
                        if(!_isStarted){
                          setState(() {
                            repetition++;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      child:Text("-"),
                      onPressed:(){
                        if(!_isStarted){setState(() {
                          work--;
                        });}
                      } ,
                    ),
                    Text("Work=$work"),
                    RaisedButton(
                      child: Text("+"),
                      onPressed: (){
                        if(!_isStarted){setState(() {
                          work++;
                        });}
                      },
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      child:Text("-"),
                      onPressed:(){
                        if(!_isStarted){setState(() {
                          rest--;
                        });}
                      } ,
                    ),
                    Text("Rest=$rest"),
                    RaisedButton(
                      child: Text("+"),
                      onPressed: (){
                        if(!_isStarted){setState(() {
                          rest++;
                        });}
                      },
                    ),
                  ],
                ),
              ),
              RaisedButton(
                child: Text("Start"),
                onPressed: (){
                  startTimer();

                },
              ),
              Center(
                child: CircularProgressIndicator(
                  value: progress.isNotEmpty && progress.last=='w'?_elapsed/work :_elapsed/rest,
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
