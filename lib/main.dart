import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
void main() => runApp(MyApp());

bool themeStateChecker = true;

class Api{
  getData () {
    return http.get('http://localhost:8000/history/').then((onValue) {
      return json.decode(onValue.body);
    });
  }
}

class MyApp extends StatefulWidget{
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeStateChecker ? ThemeData(brightness: Brightness.light, primaryColor: Colors.redAccent, scaffoldBackgroundColor: Colors.white) : ThemeData(brightness: Brightness.dark, primaryColor: Colors.redAccent, scaffoldBackgroundColor: Color(0xFF111111)),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Historia",
            style: TextStyle(fontSize: 24, fontFamily: "Product Sans"),
          ),
          centerTitle: false,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    themeStateChecker = !themeStateChecker;
                  });
                },
                child: Icon(Icons.lightbulb_outline),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: GestureDetector(
                onTap: (){
                  Share.share("Download Historia from App Store or Google Play Store and query your history as you would ask your mom!");
                },
                child: Icon(Icons.share),
              ),
            )
          ],
        ),
        body: Center(
          child: HomeScreen()
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(32),
        ),
        CircleAvatar(
          radius: 100,
          backgroundImage: NetworkImage("https://dewanshrawat15.github.io/prof.jpg"),
        ),
        Padding(
          padding: EdgeInsets.all(32),
        ),
        Text(
          "@dewanshrawat15",
          style: TextStyle(fontSize: 26, fontFamily: "Product Sans"),
        ),
        History()
      ],
    );
  }
}

class History extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return StreamBuilder(
      stream: Api().getData().asStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          var data = snapshot.data;
          
          return Text(
            "Success",
            style: TextStyle(fontFamily: "Product Sans", fontSize: 36),
          );
        }
        else{
          return CircularProgressIndicator();
        }
      },
    );
  }
}