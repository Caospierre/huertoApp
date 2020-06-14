import 'package:huerto_app/src/login/login_module.dart';
import 'package:flutter/material.dart';

import 'login_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final bloc = LoginModule.to.bloc<LoginBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration:  BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Started.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: bloc.controllerEmail,
              decoration: InputDecoration(labelText: "Email"),
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return 'Ingresa  tu Email';
                }
              },
            ),
            TextFormField(
              obscureText: true,
              controller: bloc.controllerPassword,
              decoration: InputDecoration(labelText: "Password"),
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return 'Ingresa tu password';
                }
              },
            ),
            
            RaisedButton(
              child: Text("Acceder"),
              onPressed: (){
                bloc.login();
              },
            ),
          ],
        ),
      ),
    );
  }
}
