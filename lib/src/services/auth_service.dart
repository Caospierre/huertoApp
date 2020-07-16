import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get_it/get_it.dart';
import 'package:huerto_app/src/bloc/login_bloc.dart';
import 'init_services.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseUser _user;
  bool _isSignedIn = false;
  String imageUrl;
  GlobalKey<FormState> _formkey;

  AuthService() {
    this._auth = FirebaseAuth.instance;
    this._googleSignIn = GoogleSignIn();
  }

  FirebaseAuth get auth => _auth;
  GoogleSignIn get googleSignIn => _googleSignIn;
  bool get isSignedIn => _isSignedIn;
  GlobalKey<FormState> get formkey => _formkey;
  set formkey(GlobalKey<FormState> formkey) => {this._formkey = formkey};

  void signin(String _email, String _password, String _name,
      BuildContext context) async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();

      try {
        AuthResult result = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
      } catch (e) {
        showError(e.toString(), context);
      }
    }
  }

  signout() async {
    _auth.signOut();
  }

  Future<FirebaseUser> getUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      await firebaseUser?.reload();
      this._user = await _auth.currentUser();
      this._isSignedIn = true;
    }
    return _user;
  }

  Future<FirebaseUser> signInWithGoogle() async {
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
      final bloc =
          LoginBloc(GetIt.I<InitServices>().hasuraService.appRepository);
      print(user.email);
      bloc.createUser(user.email);
      return user;
    } catch (e) {}
    return null;
  }

  checkAuthentication(BuildContext context, String urlPath) async {
    _auth.onAuthStateChanged.listen((user) async {
      if (user != null) {
        GetIt.I<InitServices>()
            .navigatorService
            .navigateToUrl(context, urlPath);
      }
    });
  }

  checkAuthenticationHome(BuildContext context, String urlPath) async {
    _auth.onAuthStateChanged.listen((user) async {
      if (user == null) {
        GetIt.I<InitServices>()
            .navigatorService
            .navigateToUrl(context, urlPath);
      }
    });
  }

  signup(String _email, String _password, String _name,
      BuildContext context) async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();

      try {
        AuthResult user = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        if (user != null) {
          UserUpdateInfo userUpdateInfo = UserUpdateInfo();
          userUpdateInfo.displayName = _name;
          user.user.updateProfile(userUpdateInfo);
        }
      } catch (e) {
        showError(e, context);
      }
    }
  }

  navigateToUrl(BuildContext context, String path) {
    Navigator.pushReplacementNamed(context, path);
  }

  showError(String errormessage, BuildContext context) {
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
}
