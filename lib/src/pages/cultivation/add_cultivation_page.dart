import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:huerto_app/src/bloc/cultivation_bloc.dart';
import 'package:huerto_app/src/bloc/product_bloc.dart';
import 'package:huerto_app/src/models/product_model.dart';
import 'package:huerto_app/src/services/init_services.dart';
import 'package:huerto_app/utils/utils.dart';

class AddCultivationPage extends StatefulWidget {
  final Stream<List<ProductModel>> productStream;

  AddCultivationPage(this.productStream);
  @override
  _AddCultivationPageState createState() => _AddCultivationPageState();
}

class _AddCultivationPageState extends State<AddCultivationPage> {
  CultivationBloc cbloc;

  int productIndex = 0;
  ProductModel productSelected;

  String nameProducto = "";
  @override
  Widget build(BuildContext context) {
    cbloc = CultivationBloc(
        GetIt.I<InitServices>().hasuraService.cultivationRepository);

    return Scaffold(
      appBar: AppBar(
        title: Text("Añadir Cultivo"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        children: <Widget>[
          showImageProduct(),
          _productCultivation(),
          Divider(),
          _nameCultivation(),
          Divider(),
          _descriptionCultivation(),
          Divider(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          int idUser = GetIt.I<InitServices>().authService.userLogin.id;

          cbloc.createCultivation(idUser, this.productIndex);
          Navigator.pop(context);
        },
      ),
    );
  }

  Container showImageProduct() {
    return Container(
        margin: EdgeInsets.only(right: 10.0, bottom: 20.0),
        height: 285.0,
        width: 50.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          image: DecorationImage(
            image: this.productSelected != null
                ? NetworkImage(
                    this.productSelected.photo,
                  )
                : AssetImage(AvailableImages.logo),
            fit: BoxFit.fill,
          ),
        ));
  }

  Widget _nameCultivation() {
    return TextFormField(
      controller: cbloc.controllerName,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: 'Nombre Del Cultivo',
        labelText: 'Nombre',
        suffixIcon: ImageIcon(new NetworkImage(
            "https://image.flaticon.com/icons/png/512/25/25195.png")),
        icon: ImageIcon(new NetworkImage(
            "https://image.flaticon.com/icons/png/512/25/25207.png")),
      ),
      validator: (String value) {
        if (value.trim().isEmpty) {
          return 'Ingresa El Nombre Del Cultivo';
        }
      },
    );
  }

  Widget _descriptionCultivation() {
    return TextFormField(
      controller: cbloc.controllerDescription,
      maxLines: 8,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: 'Descripción Del Cultivo',
        labelText: 'Descripción',
        //suffixIcon: ImageIcon(new NetworkImage("https://cdn.icon-icons.com/icons2/2249/PNG/512/tooltip_text_outline_icon_139004.png")),
        icon: ImageIcon(new NetworkImage(
            "https://cdn.icon-icons.com/icons2/1863/PNG/512/description_119232.png")),
      ),
      validator: (String value) {
        if (value.trim().isEmpty) {
          return 'Ingresa El Nombre Del Cultivo';
        }
      },
    );
  }

  List<DropdownMenuItem<ProductModel>> getOptionsDropdown(
      List<ProductModel> lt) {
    return lt.map((ProductModel product) {
      return new DropdownMenuItem<ProductModel>(
        value: product,
        child: new Text(
          product.name,
          style: new TextStyle(color: Colors.black),
        ),
      );
    }).toList();
  }

  Widget _productCultivation() {
    return Row(
      children: <Widget>[
        ImageIcon(new NetworkImage(
            "https://image.flaticon.com/icons/png/512/1146/1146445.png")),
        SizedBox(width: 30.0),
        Expanded(
            child: StreamBuilder<List<ProductModel>>(
                stream: GetIt.I<InitServices>().preferencesService.products,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('Empty');
                  }

                  return new DropdownButton<ProductModel>(
                    hint: new Text("Selecciona un producto"),
                    value: this.productSelected,
                    onChanged: (ProductModel newValue) {
                      setState(() {
                        this.productSelected = newValue;
                        this.productIndex = this.productSelected.id;

                        cbloc.controllerName.text = this.productSelected.name;
                      });
                    },
                    items: getOptionsDropdown(snapshot.data),
                  );
                })),
      ],
    );
  }
}
