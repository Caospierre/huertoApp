import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:huerto_app/src/models/product_model.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/src/models/user_model.dart';
import 'package:huerto_app/src/models/cultivation_model.dart';
import 'package:rxdart/subjects.dart';

class AppBloc extends BlocBase {
  var userController = BehaviorSubject<UserModel>();
  var cultivationController = BehaviorSubject<CultivationModel>();
  var productController = BehaviorSubject<ProductModel>();
  var publicationController = BehaviorSubject<publicationModel>();
  
  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    userController.close();
    cultivationController.close();
    productController.close();
    publicationController.close();
    super.dispose();
  }
}
