import 'package:flutter/material.dart';
import 'package:huerto_app/src/bloc/cultivation_bloc.dart';
import 'package:huerto_app/src/module/cultivation_module.dart';

class AddCultivationPage extends StatefulWidget {
  @override
  _AddCultivationPageState createState() => _AddCultivationPageState();
}

class _AddCultivationPageState extends State<AddCultivationPage> {

  final bloc = CultivationModule.to.bloc<CultivationBloc>();
  List<String> _powers = ['Fly','Lightning','Super strength','super encouragement'];

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
        onPressed: (){},
      ),
    );
  }

  Widget _nameCultivation() {
    return TextFormField(
      controller: bloc.controllerName,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        hintText: 'Nombre Del Cultivo',
        labelText: 'Nombre',
        suffixIcon: ImageIcon(new NetworkImage("https://image.flaticon.com/icons/png/512/25/25195.png")),
        icon: ImageIcon(new NetworkImage("https://image.flaticon.com/icons/png/512/25/25207.png")),
      ),
      validator: (String value){
        if(value.trim().isEmpty){
          return 'Ingresa El Nombre Del Cultivo';
        }
      },
    );
  }

  Widget _descriptionCultivation() {
    return TextFormField(
      controller: bloc.controllerDescription,
      maxLines: 8,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        hintText: 'Descripción Del Cultivo',
        labelText: 'Descripción',
        //suffixIcon: ImageIcon(new NetworkImage("https://cdn.icon-icons.com/icons2/2249/PNG/512/tooltip_text_outline_icon_139004.png")),
        icon: ImageIcon(new NetworkImage("https://cdn.icon-icons.com/icons2/1863/PNG/512/description_119232.png")),
      ),
      validator: (String value){
        if(value.trim().isEmpty){
          return 'Ingresa El Nombre Del Cultivo';
        }
      },
    );
  }




  List<DropdownMenuItem<String>> getOptionsDropdown(){
    List<DropdownMenuItem<String>> list = new List();
    _powers.forEach((power){
      list.add(DropdownMenuItem(
        child: Text(power),
        value: power,
      ));
    });

    return list;
  }

  Widget _productCultivation() {
    return Row(
      children: <Widget>[
        ImageIcon(new NetworkImage("https://image.flaticon.com/icons/png/512/1146/1146445.png")),
        SizedBox(width: 30.0),
        Expanded(
            child: DropdownButton(
            value: null,
            items: getOptionsDropdown(),
            onChanged: (opt){
              setState(() {
              });
            },
          ),
        ),
      ],
    );
  }

}