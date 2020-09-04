import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:huerto_app/src/bloc/cultivation_phase_bloc.dart';
import 'package:huerto_app/src/bloc/product_bloc.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/src/models/user_cultivation_phase_model.dart';
import 'package:huerto_app/src/routes/router.dart';
import 'package:huerto_app/src/services/init_services.dart';
import 'package:huerto_app/src/widgets/home/price_rating_bar.dart';
import 'package:huerto_app/src/widgets/home/publication_card.dart';
import 'package:huerto_app/src/widgets/home/rating_bar.dart';
import 'package:huerto_app/utils/colors.dart';

// ignore: must_be_immutable
class SavedPage extends StatelessWidget {
  final Stream<List<PublicationModel>> publicationStream;

  SavedPage(this.publicationStream);
  BuildContext context;
  bool isOddNumber(int number) {
    return number % 2 == 0 ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final _filledCircle = Container(
      height: 4.0,
      width: 4.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white60,
      ),
    );
    final _name = Text(
      "No Existe Cultivo",
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );

    final _location = Row(
      children: <Widget>[
        Text(
          "Locación",
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.white60,
          ),
        ),
        SizedBox(width: 5.0),
        _filledCircle,
        SizedBox(width: 5.0),
        Text(
          "Tipo De Cultivo",
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.white60,
          ),
        ),
      ],
    );

    final _rating = Row(
      children: <Widget>[
        RatingBar(rating: .0, color: Colors.white),
        SizedBox(width: 5.0),
        _filledCircle,
        SizedBox(width: 5.0),
        PriceRatingBar(rating: 0),
      ],
    );

    final _details = Positioned(
      bottom: 20.0,
      left: 10.0,
      right: 10.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
            height: screenHeight * .15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[_name, _location, _rating],
            ),
          ),
        ),
      ),
    );

    this.context = context;
    final body = SingleChildScrollView(
        child: StreamBuilder<List<PublicationModel>>(
      stream: this.publicationStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.length == 0) {
          return GestureDetector(
            child: Stack(
              children: <Widget>[
                Hero(
                  tag: 0,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    height: screenHeight * 0.4,
                    width: screenWidth * 0.45,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://live.staticflickr.com/2213/2227852450_cf1a392514_b.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                _details,
                FloatingActionButton.extended(
                  onPressed: () {
                    addCrowd();
                  },
                  label: Text('Agregar'),
                  icon: Icon(Icons.add_circle_outline),
                  backgroundColor: primaryGradientStart,
                ),
              ],
            ),
          );
        } else {
          return Stack(
            alignment: Alignment.center,
            children: _buildComponents(snapshot.data),
          );
        }
      },
    ));
    return body;
  }

  void addCrowd() {
    Navigator.pushNamed(context, NavigatorToPath.AddCultivation,
        arguments: null);
  }

  List<Widget> _buildComponents(List<PublicationModel> publications) {
    List<Widget> componentList = new List();

    FloatingActionButton button = FloatingActionButton.extended(
      onPressed: () {
        addCrowd();
      },
      label: Text('Agregar'),
      icon: Icon(Icons.add_circle_outline),
      backgroundColor: primaryGradientStart,
    );
    Container btnCon = Container(alignment: Alignment.topCenter, child: button);
    componentList.add(buildList(publications));
    componentList.add(btnCon);
    return componentList;
  }

/*
 color: Colors.white,
      elevation: 4.0,
      onPressed: () {
        onLongPressButtons(img);
      },
      height: height,
      shape: CircleBorder(),
      child: Container(
        height: 40.0,
        child: Image.asset(
          img,
          height: imageSize,
          width: imageSize,
        ),
      ),
 */
  Widget buildList(List<PublicationModel> list) {
    List<PublicationModel> leftSide = [];
    List<PublicationModel> rightSide = [];
    print("TAM: " + list.length.toString());
    list.forEach((publication) {
      int index = list.indexOf(publication);
      bool isOddNum = isOddNumber(index);
      isOddNum ? rightSide.add(publication) : leftSide.add(publication);
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: rightSide
              .map((res) => PublicationCard(publication: res))
              .toList(),
        ),
        Column(
          children:
              leftSide.map((res) => PublicationCard(publication: res)).toList(),
        ),
      ],
    );
  }
}
