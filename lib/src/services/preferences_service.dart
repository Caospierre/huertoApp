import 'dart:async';
import 'package:huerto_app/src/models/product_model.dart';
import 'package:huerto_app/src/models/publicacion_interested_users.dart';
import 'package:huerto_app/src/models/user_cultivation_phase_model.dart';
import 'package:huerto_app/src/repository/cultivation_phase_repository.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:huerto_app/utils/api_info.dart';

class PreferencesService {
  Stream<List<ProductModel>> _products;
  Stream<List<UserCultivationPhaseModel>> _productPhase;
  CultivationPhaseRepository _cultivationPhaseRepository;
  Stream<List<PublicationInterestedUserModel>> _mypublish;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  PreferencesService() {
    this._cultivationPhaseRepository = new CultivationPhaseRepository();
    this._firebaseMessaging = FirebaseMessaging();
  }
  FirebaseMessaging get firebaseMessaging => _firebaseMessaging;
  Stream<List<PublicationInterestedUserModel>> get mypublish => _mypublish;
  set mypublish(Stream<List<PublicationInterestedUserModel>> mypublish) =>
      {this._mypublish = mypublish};
  Stream<List<ProductModel>> get products => _products;
  set products(Stream<List<ProductModel>> products) =>
      {this._products = products};
  Stream<List<UserCultivationPhaseModel>> get productPhase => _productPhase;
  void setproductPhase(int idpub) => {
        this._productPhase =
            this._cultivationPhaseRepository.getUserCultivationPhase(idpub)
      };

  Future<Map<String, dynamic>> sendAndRetrieveMessage(
      String user, String numbephone, String image, String description) async {
    await _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: false),
    );

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Existe Una Nueva Publicacion',
            'title': 'Revisalo Te Puede Interesar'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'user': '$user',
            'number_phone': '$numbephone',
            'image': '$image',
            'description': '$description',
          },
          'to': await _firebaseMessaging.getToken(),
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }
}
