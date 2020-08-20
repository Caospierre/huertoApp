import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:huerto_app/src/bloc/home_bloc.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/src/services/init_services.dart';
import 'package:huerto_app/utils/colors.dart';
import 'package:huerto_app/src/pages/home/tabs/account.dart';
import 'package:huerto_app/src/pages/home/tabs/search.dart';
import 'package:huerto_app/src/pages/home/tabs/saved.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bloc = HomeBloc(GetIt.I<InitServices>().hasuraService.appRepository, 5);
  Stream<List<PublicationModel>> slistp;
  Stream<List<PublicationModel>> cultlist;
  Stream<List<PublicationModel>> transslist;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser user;
  bool isSignedIn = false;
  String imageUrl;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/signin');
      }
    });
  }

  getUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser();

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isSignedIn = true;
        this.imageUrl = user.photoUrl;
      });
    }
    //print(" is the user ${user.photoUrl}");
  }

  signout() async {
    _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text("Mi cosecha",
          style: TextStyle(color: statusBarColor, fontSize: 28.0)),
      centerTitle: true,
      bottom: TabBar(
        unselectedLabelColor: unselectedTabLabelColor,
        labelColor: Theme.of(context).accentColor,
        labelPadding: EdgeInsets.only(left: 0.0, right: 0.0),
        indicatorWeight: 5.0,
        indicator: BoxDecoration(
          gradient: primaryGradient,
        ),
        tabs: <Widget>[
          _buildTab(Icons.shopping_basket),
          _buildTab(Icons.search),
          _buildTab(Icons.account_circle),
        ],
      ),
    );
    this.slistp = bloc.publicationsController;
    this.cultlist = bloc.cultivationController;
    this.transslist = bloc.transaccionController;
    final body = TabBarView(
      children: [
        SavedPage(this.cultlist),
        SearchPage(this.slistp),
        //AccountPage(),
        AccountPage(this.transslist),
      ],
    );

    return DefaultTabController(
      length: 3,
      child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/Started.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            appBar: appBar,
            body: body,
          )),
    );
  }

  Widget _buildTab(IconData icon) {
    return Container(
      height: 40.0,
      alignment: Alignment.center,
      color: Colors.white,
      child: Icon(icon, size: 40.0),
    );
  }
}
