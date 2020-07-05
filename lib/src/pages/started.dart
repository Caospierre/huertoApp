import 'package:flutter/material.dart';
import 'package:huerto_app/src/module/index/app_module.dart';

class Started extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Start(),
    );
  }
}

class Start extends StatefulWidget {
  @override
  _Start createState() => new _Start();
}

class _Start extends State<Start> {
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
            Text(
              "Mi Cosecha",
              style: TextStyle(color: Colors.green, fontSize: 30),
            ),
            new IconButton(
                icon: new Icon(Icons.label_important),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AppModule()),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
