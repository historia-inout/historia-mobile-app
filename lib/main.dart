import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
void main() => runApp(MyApp());

bool themeStateChecker = true;

class Api{
  getData () {
    return http.get('http://localhost:8000/history/mobile/api/').then((onValue) {
      return json.decode(onValue.body);
    });
  }
}

final theme_color = Colors.redAccent;

class MyApp extends StatefulWidget{
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeStateChecker ? ThemeData(brightness: Brightness.light, primarySwatch: Colors.red, primaryColor: Colors.redAccent, scaffoldBackgroundColor: Colors.white) : ThemeData(brightness: Brightness.dark, primaryColor: Colors.redAccent, scaffoldBackgroundColor: Color(0xFF111111), primarySwatch: Colors.red),
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
                  setState(() {
                    
                  });
                },
                child: Icon(Icons.refresh),
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
        body: SingleChildScrollView(
          child: Center(
            child: HomeScreen()
          ),
        ),
        floatingActionButton: pushButtonSearch()
      ),
    );
  }
}

class pushButtonSearch extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(12),
      child: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => QueryScreen()
            ),
          );
        },
        child: Icon(Icons.search),
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
        Padding(
          padding: EdgeInsets.all(32),
        ),
        Text(
          "Your History",
          style: TextStyle(fontSize: 26, fontFamily: "Product Sans"),
        ),
        Padding(
          padding: EdgeInsets.all(18),
        ),
        HistoryState()
      ],
    );
  }
}

class HistoryState extends StatefulWidget{
  @override
  History createState() => History();
}

class History extends State<HistoryState>{
  @override
  Widget build(BuildContext context){
    return Container(
        height: MediaQuery.of(context).size.height - 120,
        child: StreamBuilder(
          stream: Api().getData().asStream(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.hasData){
              var data = snapshot.data;
              var n = data["collection"].length;
              var dataArr = data["collection"];
              // print(dataArr);
              // return Text("Working on it! ");
              return ListView.builder(
                itemCount: n,
                itemBuilder: (BuildContext context, int index) {
                  var title = dataArr[index]['title'];
                  var subtitle = dataArr[index]['url'];
                  var iconUrl = dataArr[index]['icon'];
                  return InkWell(
                    onTap: () async{
                      var tempUrl = subtitle;
                      if(await canLaunch(tempUrl) != null){
                        await launch(tempUrl);
                      }
                    },
                    child: ListTile(
                      title: Text("$title"),
                      subtitle: Text("$subtitle"),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: (iconUrl.length == 1) ? NetworkImage("https://img.rawpixel.com/s3fs-private/rawpixel_images/website_content/v156-tang-10-icons_2.jpg?auto=format&bg=F4F4F3&con=3&cs=srgb&dpr=1&fm=jpg&ixlib=php-3.1.0&mark=rawpixel-watermark.png&markalpha=90&markpad=13&markscale=10&markx=25&q=75&usm=15&vib=3&w=1200&s=a9bce8adf6b8b3fe01294ef595a03d4d") : NetworkImage("$iconUrl"),
                      ),
                    ),
                  );
                },
              );
            }
            else{
              return CircularProgressIndicator();
            }
          },
        )
    );
  }
}

class QueryScreen extends StatefulWidget{
  @override
  QueryScreenState createState() => QueryScreenState();
}

class QueryScreenState extends State<QueryScreen>{

  FocusNode myFocusNode = new FocusNode();
  final queryFieldController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Query",
          style: TextStyle(
            fontSize: 24,
            fontFamily: "Product Sans"
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            Padding(
              padding: EdgeInsets.only(left: 18, right: 18),
              child: TextField(
                focusNode: myFocusNode,
                onSubmitted: (val) async {
                  print(val);
                },
                cursorColor: theme_color,
                controller: queryFieldController,
                autocorrect: false,
                style: TextStyle(color: theme_color),
                decoration: InputDecoration(
                  enabledBorder: new UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: new UnderlineInputBorder(
                    borderSide: BorderSide(color: theme_color, width: 1.0),
                  ),
                  icon: Icon(Icons.search, color: theme_color),
                  labelText: 'Query',
                  labelStyle: TextStyle(color: theme_color),
                ),
              ),
            ),
            HistoryState()
          ],
        ),
      )
    );
  }
}