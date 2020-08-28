import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:huerto_app/src/bloc/home_bloc.dart';
import 'package:huerto_app/src/bloc/login_bloc.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/src/models/user_model.dart';
import 'package:huerto_app/src/pages/home/tabs/account.dart';
import 'package:huerto_app/src/pages/home/tabs/saved.dart';
import 'package:huerto_app/src/pages/home/tabs/search.dart';
import 'package:huerto_app/src/services/init_services.dart';
import 'package:huerto_app/utils/colors.dart';

class TestPage extends StatefulWidget {
  final int idUser;
  TestPage({@required this.idUser});
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  var barTitle = ['Mi Cosecha', 'Trueque o Compra', 'Perfil', 'Guia'];
  int indexTitle = 0;
  HomeBloc hbloc;
  Stream<List<PublicationModel>> slistp;
  Stream<List<PublicationModel>> cultlist;
  Stream<List<PublicationModel>> transslist;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  BuildContext context;
  FirebaseUser user;
  UserModel _userLogin = GetIt.I<InitServices>().authService.userLogin;

  bool isSignedIn = false;
  String imageUrl;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _getToken() {
    _firebaseMessaging.getToken().then((token) {
      print("Device Token: $token");
    });
  }

  List<Message> messagesList = new List<Message>();
 
  _configureFirebaseListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        _setMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        _setMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        _setMessage(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
  }

  _setMessage(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
    String mMessage = data['message'];
    print("Title: $title, body: $body, message: $mMessage");
    setState(() {
      Message msg = Message(title, body, mMessage);
      messagesList.add(msg);
      print(messagesList);
    });
}

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user == null) {
        try {
          Navigator.pushReplacementNamed(this.context, '/signin');
        } catch (e) {
          print(e.toString());
        }
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
        final bloc =
            LoginBloc(GetIt.I<InitServices>().hasuraService.appRepository);
        bloc.isUser(user.email);
        this._userLogin = bloc.user;
      });

      if (widget.idUser != null) {
        hbloc = HomeBloc(
            GetIt.I<InitServices>().hasuraService.appRepository, widget.idUser);
        this.slistp = hbloc.publicationsController;
        this.cultlist = hbloc.cultivationController;
        this.transslist = hbloc.transaccionController;
      }
    }
    // print("${user.displayName} is the user ${user.photoUrl}");
  }

  signout() async {
    _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    this.getUser();
    _getToken();
    _configureFirebaseListeners();
  }

  @override
  Widget build(BuildContext context) {
    setState(() => this.context = context);

    final appBar = AppBar(
      title: Text(this.barTitle[this.indexTitle],
          style: TextStyle(color: statusBarColor, fontSize: 28.0)),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: signout,
        )
      ],
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
          _buildTab(Icons.book),
        ],
        onTap: (value) {
          setState(() {
            this.indexTitle = value;
          });
        },
      ),
    );
    final body = TabBarView(
      children: [
        SavedPage(this.cultlist),
        SearchPage(this.slistp),
        AccountPage(this.transslist),
        //SavedPage(this.cultlist), //AccountPage(),
        Container(
          child: ListView.builder(
        itemCount: null == messagesList ? 0 : messagesList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                messagesList[index].message,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
      ),
        ),
      ],
    );

    return DefaultTabController(
      length: 4,
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

class Message {
  String title;
  String body;
  String message;
  Message(title, body, message) {
    this.title = title;
    this.body = body;
    this.message = message;
  }
}