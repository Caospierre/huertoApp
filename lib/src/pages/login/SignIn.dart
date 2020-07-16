import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:get_it/get_it.dart';
import 'package:huerto_app/src/services/init_services.dart';
import 'package:huerto_app/src/module/login_module.dart';
import 'package:huerto_app/src/bloc/login_bloc.dart';
import 'package:huerto_app/src/routes/router.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final bloc = LoginModule.to.bloc<LoginBloc>();
  String _name, _email, _password;
  navigateToSignUpScreen() {
    GetIt.I<InitServices>()
        .navigatorService
        .navigateToUrl(context, NavigatorToPath.SignUP);
  }

  void signin() {
    GetIt.I<InitServices>()
        .authService
        .signin(_email, _password, _name, context);
    bloc.login();
  }

  @override
  void initState() {
    GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    print('Entrosss');
    GetIt.I<InitServices>().authService.formkey = _formkey;
    GetIt.I<InitServices>()
        .authService
        .checkAuthentication(context, NavigatorToPath.Home);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text('Sign In'),
//      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Started.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.fromLTRB(30, 50, 30, 40),
        child: Center(
          child: ListView(
            children: <Widget>[
              Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 50.0),
                      child: Image(
                        image: AssetImage('assets/images/Tree.png'),
                        height: 100,
                        width: 100,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Form(
                        key: GetIt.I<InitServices>().authService.formkey,
                        child: Column(
                          children: <Widget>[
                            // E-mail TextField
                            Container(
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: bloc.controllerEmail,
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white),
                                validator: (input) {
                                  if (input.isEmpty) {
                                    return ' Email';
                                  }
                                },
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    contentPadding: EdgeInsets.all(15),
                                    suffixIcon: Icon(
                                      Icons.account_circle,
                                      color: Colors.white,
                                    ),
                                    filled: true,
                                    fillColor: Colors.blue,
                                    focusColor: Colors.blue,
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    hintStyle: TextStyle(color: Colors.white),
                                    hintText: 'E-mail'),
                                onSaved: (input) => this._email = input,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            // Password TextField
                            Container(
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: bloc.controllerPassword,
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white),
                                obscureText: true,
                                validator: (input) {
                                  if (input.length < 6) {
                                    return 'Password debe ser de 6 digitos';
                                  }
                                },
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    contentPadding: EdgeInsets.all(15),
                                    suffixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                    ),
                                    filled: true,
                                    fillColor: Colors.blue,
                                    focusColor: Colors.blue,
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    hintStyle: TextStyle(color: Colors.white),
                                    hintText: 'Contraseña'),
                                onSaved: (input) => this._password = input,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 60),
                            ),
                            //  Sign In button
                            RaisedButton(
                                padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(30),
                                ),
                                onPressed: signin,
                                child: Text(
                                  'Iniciar sesion',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                            ),

                            GestureDetector(
                              onTap: navigateToSignUpScreen,
                              child: Text(
                                'Create una cuenta',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.blue),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                            ),
                            Text(
                              "- OR -",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 20.0, color: Colors.blue),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                            ),
                            GoogleSignInButton(
                              onPressed: () {
                                GetIt.I<InitServices>()
                                    .authService
                                    .signInWithGoogle()
                                    .then((FirebaseUser user) => print(user))
                                    .catchError((e) => print(e));
                              },
                              borderRadius: 20,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                elevation: 20,
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(150),
                )),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Text(
                'HI',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.blue),
              )
            ],
          ),
        ),
      ),
    );
  }
}
