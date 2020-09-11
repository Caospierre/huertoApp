import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:get_it/get_it.dart';
import 'package:huerto_app/src/bloc/home_bloc.dart';
import 'package:huerto_app/src/bloc/login_bloc.dart';
import 'package:huerto_app/src/models/notification_model.dart';
import 'package:huerto_app/src/bloc/product_bloc.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/src/models/user_model.dart';
import 'package:huerto_app/src/pages/home/tabs/account.dart';
import 'package:huerto_app/src/pages/home/tabs/saved.dart';
import 'package:huerto_app/src/pages/home/tabs/search.dart';
import 'package:huerto_app/src/services/init_services.dart';
import 'package:huerto_app/utils/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

class TestPage extends StatefulWidget {
  final int idUser;
  TestPage({@required this.idUser});
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  var barTitle = ['Mi Cosecha', 'Tienda', 'Perfil', 'Notificación'];
  ProductBloc pbloc =
      ProductBloc(GetIt.I<InitServices>().hasuraService.productRepository);
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

  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _getToken() {
    _firebaseMessaging.getToken().then((token) {
      print("Device Token: $token");
    });
  }

  _saveDeviceToken() async {

    String fcmToken = await _firebaseMessaging.getToken();

    if (fcmToken != null) {
      var huertoapp = _db
          .collection('DeviceTokens')
          .document(fcmToken);

      await huertoapp.setData({
        'device_token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'user': GetIt.I<InitServices>().authService.userLogin.name,
      });
    }
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
    String uMessage = data['user'];
    String npMessage = data['number_phone'];
    String iMessage = data['image'];
    String dMessage = data['description'];
    print(
        "Titulo: $title, Cuerpo: $body, usuario: $uMessage, numero: $npMessage, imagen: $iMessage,  descripcion: $dMessage");
    setState(() {
      if (title == null && body == null) {
        Message msg = Message("Existe Una Publicación", "", uMessage, npMessage,
            iMessage, dMessage);
        messagesList.add(msg);
        print(messagesList);
      } else {
        Message msg =
            Message(title, body, uMessage, npMessage, iMessage, dMessage);
        messagesList.add(msg);
        print(messagesList);
      }
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
        GetIt.I<InitServices>().preferencesService.products =
            pbloc.productController;
        GetIt.I<InitServices>().preferencesService.mypublish =
            hbloc.myPublishController;
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
    _askPermissions();
    _saveDeviceToken();
  }

  Future<void> _askPermissions() async {
    final permissionStatus = await _getContactPermission();
    if (permissionStatus != PermissionStatus.granted) {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    final status = await Permission.contacts.status;
    if (!status.isGranted && !status.isPermanentlyDenied) {
      final result = await Permission.contacts.request();
      return result ?? PermissionStatus.undetermined;
    } else {
      return status;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw PlatformException(
          code: 'PERMISSION_DENIED',
          message: 'Access to location data denied',
          details: null);
    } else if (permissionStatus == PermissionStatus.restricted) {
      throw PlatformException(
          code: 'PERMISSION_DISABLED',
          message: 'Location data is not available on device',
          details: null);
    }
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
        unselectedLabelColor: Color(0xFF4569DB),
        labelColor: Theme.of(context).accentColor,
        labelPadding: EdgeInsets.only(left: 0.0, right: 0.0),
        indicatorWeight: 5.0,
        indicator: BoxDecoration(
          gradient: primaryGradient,
        ),
        tabs: <Widget>[
          _buildTab(Icons.shopping_basket),
          _buildTab(Icons.local_grocery_store),
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
        showNotifications()
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


  // Advanced using of alerts
  _onAlertWithStylePressedContact(context) {
    // Reusable alert style
    var alertStyle = AlertStyle(
        animationType: AnimationType.fromTop,
        isCloseButton: false,
        isOverlayTapDismiss: false,
        descStyle: TextStyle(fontWeight: FontWeight.bold),
        animationDuration: Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle: TextStyle(
          color: Colors.red,
        ),
        constraints: BoxConstraints.expand(width: 300));

    // Alert dialog using custom alert style
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.success,
      title: "Contacto",
      desc: "Contacto Guardado Exitosamente",
      buttons: [
        DialogButton(
          child: Text(
            "Cerrar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }

  // Advanced using of alerts
  _onAlertWithStylePressedMessage(context) {
    // Reusable alert style
    var alertStyle = AlertStyle(
        animationType: AnimationType.fromTop,
        isCloseButton: false,
        isOverlayTapDismiss: false,
        descStyle: TextStyle(fontWeight: FontWeight.bold),
        animationDuration: Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle: TextStyle(
          color: Colors.red,
        ),
        constraints: BoxConstraints.expand(width: 300));

    // Alert dialog using custom alert style
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.success,
      title: "Mensaje",
      desc: "Mensaje Enviado Exitosamente",
      buttons: [
        DialogButton(
          child: Text(
            "Cerrar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }

  Container showNotifications() {
    return Container(
      child: ListView.builder(
        itemCount: null == messagesList ? 0 : messagesList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Image(
                  image: new NetworkImage(messagesList[index].image),
                  fit: BoxFit.cover,
                  width: 400,
                ),
                ListTile(
                  leading: Icon(Icons.store),
                  title: Text(messagesList[index].title),
                  subtitle: Text(
                    messagesList[index].user +
                        "\n" +
                        messagesList[index].numberphone,
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    messagesList[index].description,
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: [
                    FlatButton(
                      textColor: const Color(0xFF6200EE),
                      onPressed: () async {
                        // Perform some action
                        List<Item> phone = new List<Item>();
                        phone.add(
                            new Item(value: messagesList[index].numberphone));
                        Contact contact = Contact(
                            givenName: messagesList[index].user, phones: phone);
                        await Contacts.addContact(contact);
                        _onAlertWithStylePressedContact(context);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.contacts),
                          Text('Guardar Contacto'),
                        ],
                      ),
                    ),
                    FlatButton(
                      textColor: const Color(0xFF6200EE),
                      onPressed: () {
                        // Perform some action
                        FlutterOpenWhatsapp.sendSingleMessage("+593"+messagesList[index].numberphone,"Estoy Intereaso En Tu Publicacion");
                        _onAlertWithStylePressedMessage(context);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.message),
                          Text('Enviar Mensaje'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
