import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:huerto_app/src/bloc/cultivation_bloc.dart';
import 'package:huerto_app/src/bloc/home_bloc.dart';
import 'package:huerto_app/src/bloc/product_bloc.dart';
import 'package:huerto_app/src/models/product_model.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/src/services/init_services.dart';

class AddCultivationPage extends StatefulWidget {
  final Stream<List<PublicationModel>> publicationStream;

  AddCultivationPage(this.publicationStream);
  @override
  _AddCultivationPageState createState() => _AddCultivationPageState();
}

class _AddCultivationPageState extends State<AddCultivationPage> {
  final cbloc = CultivationBloc(
      GetIt.I<InitServices>().hasuraService.cultivationRepository);
  final pbloc =
      ProductBloc(GetIt.I<InitServices>().hasuraService.productRepository);
  int productIndex = 0;
  Stream<List<ProductModel>> productStream;
  int idProducto;
  String nameProducto = "--NoNe---";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Añadir Cultivo"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        children: <Widget>[
          _nameCultivation(),
          Divider(),
          _descriptionCultivation(),
          Divider(),
          _productCultivation(),
          Divider(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          int idUser = GetIt.I<InitServices>().authService.userLogin.id;
          cbloc.createCultivation(idUser, this.idProducto);
        },
      ),
    );
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

  List<DropdownMenuItem<String>> getOptionsDropdown(List<ProductModel> lt) {
    List<DropdownMenuItem<String>> list = new List();
    lt.forEach((element) {
      list.add(DropdownMenuItem(
        child: Text(element.name),
        value: productIndex.toString(),
      ));
      this.productIndex++;
    });
    this.productIndex = 0;
    return list;
  }

  Widget _productCultivation() {
    this.productStream = pbloc.productController;
    return Row(
      children: <Widget>[
        ImageIcon(new NetworkImage(
            "https://image.flaticon.com/icons/png/512/1146/1146445.png")),
        SizedBox(width: 30.0),
        Expanded(
            child: StreamBuilder<List<ProductModel>>(
                stream: this.productStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('Empty');
                  } else {}

                  return DropdownButton(
                    items: getOptionsDropdown(snapshot.data),
                    value: '0',
                    onChanged: (opt) {
                      setState(() {
                        this.productIndex = int.parse(opt);
                      });
                    },
                  );
                })),
      ],
    );
  }
}
