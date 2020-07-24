import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:line_icons/line_icons.dart';
import 'package:huerto_app/utils/utils.dart';
import 'package:huerto_app/src/widgets/home/price_rating_bar.dart';
import 'package:huerto_app/src/widgets/home/rating_bar.dart';

class PublicationDetailsPage extends StatelessWidget {
  final PublicationModel publication;

  PublicationDetailsPage({@required this.publication});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final cancelBtn = Positioned(
      top: 50.0,
      left: 20.0,
      child: Container(
        height: 35.0,
        width: 35.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.withOpacity(0.5),
        ),
        child: IconButton(
          icon: Icon(LineIcons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          iconSize: 20.0,
        ),
      ),
    );

    final imageBg = Hero(
      tag: publication.id,
      child: Container(
        height: screenHeight * 0.7,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(publication.cultivation.product.photo),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    final _filledCircle = Container(
      height: 4.0,
      width: 4.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white60,
      ),
    );

    final _name = Text(
      publication.cultivation.product.name,
      style: TextStyle(
        color: Colors.white,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );

    final _location = Row(
      children: <Widget>[
        Text(
          publication.location,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white60,
          ),
        ),
        SizedBox(width: 5.0),
        _filledCircle,
        SizedBox(width: 5.0),
        Text(
          publication.type,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white60,
          ),
        ),
      ],
    );

    final _rating = Row(
      children: <Widget>[
        RatingBar(
          rating: publication.rating + .0,
          color: Colors.white,
          size: 20.0,
        ),
        SizedBox(width: 5.0),
        _filledCircle,
        SizedBox(width: 5.0),
        PriceRatingBar(rating: publication.priceScale, size: 20.0),
      ],
    );

    final _details = Positioned(
      top: screenHeight * 0.50,
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
    final _distance = Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Text(
        publication.distance,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
          color: Colors.blueGrey,
        ),
      ),
    );

    final _description = Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Text(
        publication.description,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15.0,
          color: Colors.blueGrey,
        ),
      ),
    );

    final _openingHours = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Disponible!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Row(
            children: <Widget>[
              Text(
                "View hours",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: Colors.grey.withOpacity(0.4),
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.withOpacity(0.4))
            ],
          )
        ],
      ),
    );

    final _footerBtns = Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildIconCard(
            context,
            AvailableImages.website,
            "Cultivo",
            Color(0xFFffc751),
          ),
          _buildIconCard(
            context,
            AvailableImages.iphone,
            "Guia",
            Color(0xFF68c1c2),
          ),
          _buildIconCard(
            context,
            AvailableImages.navigate,
            "JEAN",
            Color(0xFFACE3EE),
          ),
        ],
      ),
    );

    final secondSection = Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        height: screenHeight * 0.33,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _distance,
            _description,
            _openingHours,
            _footerBtns
          ],
        ),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(height: screenHeight),
                imageBg,
                cancelBtn,
                _details,
                secondSection
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconCard(
      BuildContext context, String img, String name, Color color) {
    return Container(
      child: Column(
        children: <Widget>[
          Image.asset(img, height: 70.0),
          SizedBox(
            height: 3.0,
          ),
          Text(
            name,
            style: TextStyle(color: color),
          )
        ],
      ),
    );
  }
}
