import 'package:flutter/material.dart';

class AddCultivationPage extends StatefulWidget {
  @override
  _AddCultivationPageState createState() => _AddCultivationPageState();
}

class _AddCultivationPageState extends State<AddCultivationPage> {

  String _selectedOption = 'Fly';
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
    return TextField(
      //autofocus: true,
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
      onChanged: (value){
        setState(() {
        });
      },
    );
  }

  Widget _descriptionCultivation() {
    return TextField(
      //autofocus: true,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        hintText: 'Descripción Del Cultivo',
        labelText: 'Descripción',
        suffixIcon: ImageIcon(new NetworkImage("https://cdn.icon-icons.com/icons2/2249/PNG/512/tooltip_text_outline_icon_139004.png")),
        icon: ImageIcon(new NetworkImage("https://cdn.icon-icons.com/icons2/1863/PNG/512/description_119232.png")),
      ),
      onChanged: (value){
        setState(() {
        });
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
            value: _selectedOption,
            items: getOptionsDropdown(),
            onChanged: (opt){
              setState(() {
                _selectedOption = opt;
              });
            },
          ),
        ),
      ],
    );
  }

}