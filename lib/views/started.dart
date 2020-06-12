import 'package:flutter/material.dart';


class started extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: start(),
    );
  }

}

class start extends StatefulWidget{
  @override
  _start createState() => new _start();
}

class _start extends State<start>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Started.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(70),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/images/Tree.png"),
            Text("Mi Cosecha", style: TextStyle(color: Colors.green,fontSize: 30),),
            new IconButton(icon: new Icon(Icons.label_important), onPressed: (){

            }),
          ],),
      ),
    );
  }
}