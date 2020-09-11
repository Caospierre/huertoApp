import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:get_it/get_it.dart';
import 'package:huerto_app/src/models/publicacion_interested_users.dart';
import 'package:huerto_app/src/models/review.dart';
import 'package:huerto_app/src/routes/router.dart';
import 'package:huerto_app/src/services/init_services.dart';
import 'package:huerto_app/src/widgets/home/rating_bar.dart';
import 'package:huerto_app/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewCard extends StatefulWidget {
  final PublicationInterestedUserModel review;

  const ReviewCard({Key key, @required this.review}) : super(key: key);

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
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
            arguments: widget.review.publication);
      },
      child: Transform.translate(
        offset: Offset(250, 0),
        child: Container(
          margin: EdgeInsets.only(right: 10.0),
          alignment: Alignment.topRight,
          height: 40.0,
          width: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            image: DecorationImage(
              image: NetworkImage(
                widget.review.publication.cultivation.product.photo,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );

    final _name = InkWell(
      onTap: () {
        Navigator.pushNamed(context, NavigatorToPath.Publication,
            arguments: widget.review.publication);
      },
      child: Text(
        widget.review.publication.cultivation.product.name != null
            ? widget.review.publication.cultivation.product.name
            : "Producto Sin Nombre",
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    final _location = Row(
      children: <Widget>[
        Text(
          widget.review.users.name != null
              ? widget.review.users.name
              : widget.review.users.email,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.green,
          ),
        ),
        SizedBox(width: 5.0),
        _filledCircle,
        SizedBox(width: 5.0),
        Text(
          widget.review.users.phone != null
              ? widget.review.users.phone
              : "Telf no registrado",
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.deepOrangeAccent,
          ),
        ),
        Container(
          child: FlatButton(
            child: Icon(
              Icons.phone,
              color: primaryColor,
            ),
            onPressed: () {
              _launchCaller();
            },
          ),
        ),
      ],
    );

    final _content = Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Text(
        widget.review.publication.cultivation.description,
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
          RatingBar(rating: widget.review.publication.rating + .0),
          SizedBox(width: 5.0),
          _filledCircle,
          SizedBox(width: 5.0),
          Text(
            widget.review.users.phone != null
                ? widget.review.publication.type
                : "Indefinido",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.green,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50.0),
            child: FloatingActionButton.extended(
              label: Text('Entregar'),
              backgroundColor: primaryColor,
              onPressed: () {
                GetIt.I<InitServices>()
                    .hasuraService
                    .cultivationPhaseRepository
                    .updateCheckedPub(widget.review.publication.id);
                notificationConfirm(
                    "Transaccion Exitosa", "Gracias por confiar en nosotros");
              },
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
      child: Stack(
        children: <Widget>[details, img],
      ),
    );
  }

  _launchCaller() async {
    var url = "tel:" + this.widget.review.users.phone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void notificationConfirm(String title, String content) {
    final popup =
        BeautifulPopup(context: context, template: TemplateNotification);
    popup.recolor(Color(0xFF5B16D0));
    popup.show(
      title: title,
      content: content,
      actions: [
        popup.button(
          label: 'Cerrar',
          onPressed: Navigator.of(context).pop,
        ),
      ],
      // bool barrierDismissible = false,
      // Widget close,
    );
  }
}
