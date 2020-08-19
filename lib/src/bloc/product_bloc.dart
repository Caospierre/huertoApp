import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/cupertino.dart';
import 'package:huerto_app/src/models/product_model.dart';
import 'package:huerto_app/src/repository/product_repository.dart';

class ProductBloc extends BlocBase {
  final ProductRepository _repository;

  ProductBloc(this._repository) {
    Observable(_repository.getProducts()).pipe(productController);
  }

  var controller = TextEditingController();
  var productController = BehaviorSubject<List<ProductModel>>();

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    controller.dispose();
    productController.close();

    super.dispose();
  }
}
