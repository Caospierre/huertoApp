import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/src/widgets/home/price_rating_bar.dart';
import 'rating_bar.dart';

class PublicationCardBig extends StatelessWidget {
  final PublicationModel publication;
  final double width;

  const PublicationCardBig(
      {Key key, @required this.publication, this.width = 0.9})
      : super(key: key);
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
          publication.location != null ? publication.location : "Indefinido",
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
        PriceRatingBar(
          rating: publication.priceScale,
          size: 20.0,
        ),
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

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Material(
          borderRadius: BorderRadius.circular(20.0),
          elevation: 4.0,
          child: Container(
            height: screenHeight * 0.6,
            width: screenWidth * width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(publication.cultivation.product.photo),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        _details
      ],
    );
  }
}
