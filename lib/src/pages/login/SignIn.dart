import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:get_it/get_it.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:huerto_app/src/bloc/login_bloc.dart';
import 'package:huerto_app/src/models/user_model.dart';
import 'package:huerto_app/src/routes/router.dart';
import 'package:huerto_app/src/services/init_services.dart';
import 'package:huerto_app/utils/utils.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  BuildContext context;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  UserModel _userLogin;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final bloc = LoginBloc(GetIt.I<InitServices>().hasuraService.appRepository);
  String _email, _passwaord;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) async {
      if (user != null) {
        try {
          bloc.isUser(user.email);
          this._userLogin = await bloc.isUser(user.email);
          Navigator.pushNamed(this.context, NavigatorToPath.Test,
              arguments: this._userLogin.id);
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }

  navigateToSignUpScreen() {
    Navigator.pushReplacementNamed(context, '/signup');
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  void signin() async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();

      try {
        AuthResult user = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _passwaord,
        );
        if (user.user != null) {
          final bloc =
              LoginBloc(GetIt.I<InitServices>().hasuraService.appRepository);
          if (user.user.email != null) {
            if (await bloc.isUser(user.user.email) != null) {
              print("Login Basic:" + _userLogin.email);
            }
          }
        }
      } catch (e) {
        showError(e.toString());
      }
    }
  }

  // ignore: missing_return
  Future<FirebaseUser> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final AuthResult authResult =
          await _auth.signInWithCredential(authCredential);
      final FirebaseUser user = authResult.user;

      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentuser = await _auth.currentUser();

      assert(user.uid == currentuser.uid);

      if (user.email != null) {
        print("LOGIN" + user.email);
        if (await bloc.isUser(user.email) == null) {
          bloc.createUser(user.email);
        }
        this._userLogin = bloc.user;
        print("Login Gooogle: " + _userLogin.email);
      }

      return user;
    } catch (e) {}
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    setState(() => this.context = context);
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
                        image: AssetImage(AvailableImages.logo),
                        height: 100,
                        width: 100,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: <Widget>[
                            // E-mail TextField
                            Container(
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white),
                                validator: (input) {
                                   if (input.isEmpty) {
                                    return 'Ingresa Un Correo';
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
                                    hintText: 'Correo Electrónico'),
                                onSaved: (input) => _email = input,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            // Password TextField
                            Container(
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white),
                                obscureText: true,
                                validator: (input) {
                                  if (input.length < 6) {
                                    return 'Password must be atleast 6 char long';
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
                                onSaved: (input) => _passwaord = input,
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
                                  'Iniciar Sesion',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                            ),
                            // Text Button to Sign Up page
                            GestureDetector(
                              onTap: navigateToSignUpScreen,
                              child: Text(
                                'Crear una Cuenta',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.blue),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                            ),
                            Text(
                              "- O -",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 20.0, color: Colors.blue),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                            ),
                            GoogleSignInButton(
                              text: 'Iniciar con Google',
                              onPressed: () {
                                _signInWithGoogle()
                                    .then((FirebaseUser user) =>
                                        print("Logeado>>" + user.toString()))
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
                'Mi Cosecha ',
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
