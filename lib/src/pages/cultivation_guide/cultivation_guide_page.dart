import 'package:huerto_app/src/bloc/products_bloc.dart';
import 'package:flutter/material.dart';

import 'package:huerto_app/src/module/products_module.dart';

class CultivationGuidePage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<CultivationGuidePage> {
  final bloc = ProductsModule.to.bloc<ProductsBloc>();

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
              onPressed: () {
                bloc.addproduct();
              },
            ),
          ],
        ),
      ),
    );
  }
}
