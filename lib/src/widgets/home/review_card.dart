import 'package:flutter/material.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/src/routes/router.dart';
import 'package:huerto_app/src/widgets/home/rating_bar.dart';

class ReviewCard extends StatelessWidget {
  final PublicationModel review;

  const ReviewCard({Key key, @required this.review}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _filledCircle = Container(
      height: 4.0,
      width: 4.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.withOpacity(0.6),
      ),
    );

    final img = GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, NavigatorToPath.Publication,
            arguments: review);
      },
      child: Container(
        margin: EdgeInsets.only(right: 10.0),
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          image: DecorationImage(
            image: NetworkImage(
              review.cultivation.product.photo,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    final _name = InkWell(
      onTap: () {
        Navigator.pushNamed(context, NavigatorToPath.Publication,
            arguments: review);
      },
      child: Text(
        review.cultivation.product.name,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    final _location = Row(
      children: <Widget>[
        Text(
          review.location != null ? review.location : "Indefinido",
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.grey.withOpacity(0.6),
          ),
        ),
        SizedBox(width: 5.0),
        _filledCircle,
        SizedBox(width: 5.0),
        Text(
          review.type,
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.grey.withOpacity(0.6),
          ),
        ),
      ],
    );

    final _content = Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Text(
        review.description,
        style: TextStyle(),
      ),
    );

    final _hr = Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      height: 0.8,
      width: MediaQuery.of(context).size.width * 0.7,
      color: Colors.grey.withOpacity(0.4),
    );

    final _rating = Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        children: <Widget>[
          RatingBar(rating: review.rating + .0),
          SizedBox(width: 5.0),
          _filledCircle,
          SizedBox(width: 5.0),
          Text(
            review.date != null ? review.date : "Indefinido",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.withOpacity(0.8),
            ),
          )
        ],
      ),
    );

    final details = Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_name, _location, _content, _rating, _hr],
      ),
    );

    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[img, details],
      ),
    );
  }
}
