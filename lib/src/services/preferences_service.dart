import 'dart:async';
import 'package:huerto_app/src/models/product_model.dart';
import 'package:huerto_app/src/models/publicacion_interested_users.dart';
import 'package:huerto_app/src/models/user_cultivation_phase_model.dart';
import 'package:huerto_app/src/repository/cultivation_phase_repository.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

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
}
