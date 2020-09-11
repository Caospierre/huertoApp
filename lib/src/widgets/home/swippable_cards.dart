import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:get_it/get_it.dart';
import 'package:huerto_app/src/bloc/publication_bloc.dart';
import 'package:huerto_app/src/models/publicacion_interested_users.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/src/pages/login/TestPage.dart';
import 'package:huerto_app/src/routes/router.dart';
import 'package:huerto_app/src/services/init_services.dart';
import 'package:huerto_app/src/widgets/home/price_rating_bar.dart';
import 'package:huerto_app/src/widgets/home/rating_bar.dart';
import 'package:huerto_app/utils/utils.dart';
import 'package:huerto_app/src/widgets/home/publication_card_big.dart';
import 'package:toast/toast.dart';

// ignore: must_be_immutable
class SwippableCards extends StatefulWidget {
  final Stream<List<PublicationModel>> publicationStream;

  SwippableCards(this.publicationStream);

  @override
  _SwippableCardsState createState() =>
      _SwippableCardsState(this.publicationStream);
}

class _SwippableCardsState extends State<SwippableCards> {
  List<Widget> cardList;
  final bloc = PublicationBloc(
      GetIt.I<InitServices>().hasuraService.publicationRepository);
  List<PublicationModel> _publicationsCopy;
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  _SwippableCardsState(Stream<List<PublicationModel>> publicationStream) {}

  void _removeCard(index, List<PublicationModel> publications) {
    setState(() {
      _publicationsCopy = publications;
      PublicationModel r = _publicationsCopy[index];
      _getSwipeCards(_publicationsCopy).removeAt(index);
      _publicationsCopy.removeAt(index);
      _publicationsCopy.insert(0, r);
      cardList = _getSwipeCards(_publicationsCopy);
    });
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
      "No Existe Publicacion",
      style: TextStyle(
        color: Colors.white,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );

    final _location = Row(
      children: <Widget>[
        Text(
          "Locación",
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white60,
          ),
        ),
        SizedBox(width: 5.0),
        _filledCircle,
        SizedBox(width: 5.0),
        Text(
          "Tipo De Publicación",
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
          rating: 0,
          color: Colors.white,
          size: 20.0,
        ),
        SizedBox(width: 5.0),
        _filledCircle,
        SizedBox(width: 5.0),
        PriceRatingBar(
          rating: 0,
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

    return Center(
        child: StreamBuilder<List<PublicationModel>>(
      stream: this.widget.publicationStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        print("" + snapshot.data.toString());
        if (snapshot.data.length == 0) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Material(
                borderRadius: BorderRadius.circular(20.0),
                elevation: 4.0,
                child: Container(
                  height: screenHeight * 0.6,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://1.bp.blogspot.com/-Y2TBmGkP1Qk/VgBv9G8EiuI/AAAAAAAAA-A/EuaExDn7iXUK3tQrvTWbLsXgtHalgbf8ACPcBGAYYCw/s1600/302.jpg"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              _details
            ],
          );
        } else {
          return Stack(
            alignment: Alignment.center,
            children: _getSwipeCards(snapshot.data),
          );
        }
      },
    ));
  }

  List<Widget> _getSwipeCards(List<PublicationModel> publications) {
    double initTop = 15.0;
    double initHor = 20.0;
    double initWidth = 0.9;
    List<Widget> cardList = new List();
    _publicationsCopy = publications;
    for (var i = 0; i < _publicationsCopy.length; i++) {
      var width;
      if (i == _publicationsCopy.length) {
        width = 0.9;
      } else if (i == _publicationsCopy.length - 1) {
        width = initWidth - 0.05;
      } else if (i == _publicationsCopy.length - 2) {
        width = initWidth - 0.1;
      } else if (i == _publicationsCopy.length - 3) {
        width = initWidth - 0.15;
      } else {
        width = initWidth - 0.2;
      }
      print(i.toString() + " " + _publicationsCopy[i].cultivation.product.name);
      cardList.add(
        Positioned(
          top: initTop * (i + 1),
          child: Draggable(
            feedback: Material(
              borderRadius: BorderRadius.circular(20.0),
              child: PublicationCardBig(publication: _publicationsCopy[i]),
            ),
            childWhenDragging: Container(),
            onDragEnd: (drag) {
              _removeCard(i, publications);
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: initHor - (3 * (i + 1)),
                vertical: 10.0,
              ),
              child: PublicationCardBig(
                publication: _publicationsCopy[i],
                width: width,
              ),
            ),
            data: _publicationsCopy[i],
          ),
        ),
      );
    }

    final footerBtns = Positioned(
      bottom: 20.0,
      left: 10.0,
      right: 10.0,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildCircularBtn(40.0, AvailableImages.back, 1),
            _buildCircularBtn(70.0, AvailableImages.hate, 2),
            _buildCircularBtn(70.0, AvailableImages.like, 3),
            _buildCircularBtn(40.0, AvailableImages.list, 4),
          ],
        ),
      ),
    );

    cardList.add(footerBtns);

    return cardList;
  }

  Widget _buildCircularBtn(double height, String img, int type) {
    double imageSize;

    if (type == 1 || type == 4) {
      imageSize = 25.0;
    } else {
      imageSize = 35.0;
    }

    return MaterialButton(
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
    );
  }

  void onLongPressButtons(String image) async {
    switch (image) {
      case AvailableImages.back:
        print("REGRESAR");
        break;
      case AvailableImages.hate:
        print("INFO PUBLICACION");
        Navigator.pushNamed(
          context,
          NavigatorToPath.Publication,
          arguments: _publicationsCopy[0],
        );
        break;
      case AvailableImages.like:

        print("ME INTERESA");
        int selectedIndex = _publicationsCopy.length - 1;
        int userid = GetIt.I<InitServices>().authService.userLogin.id;
        bool ipub = await GetIt.I<InitServices>()
            .hasuraService
            .appRepository
            .isBuy(userid, _publicationsCopy[selectedIndex].id);
        if (!ipub) {
          bloc.txtPubcontroller.text =
              _publicationsCopy[selectedIndex].id.toString();
          bloc.txtUsercontroller.text = userid.toString();
          bloc.checkPublication(_publicationsCopy[selectedIndex].users.id);
         saveMessage(_publicationsCopy[selectedIndex].cultivation.product.description,
          _publicationsCopy[selectedIndex].cultivation.product.photo,
          _publicationsCopy[selectedIndex].users.phone,
         _publicationsCopy[selectedIndex].users.name);
          notificationConfirm("Transaccion Exitosa",
              "El Anunciante se contactara contigo Pronto");
        } else {
          Toast.show(
              "Ya has mostrado tu interes por este producto,se contactaran contigo pronto",
              context,
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.BOTTOM);
        }

        break;

      case AvailableImages.list:
        print("AYUDA");
        notificationFinish("Informacion", AvailableImages.info);
        break;

      default:
    }
  }

  void notificationFinish(String title, String content) {
    final popup = BeautifulPopup(
      context: context,
      template: TemplateGift,
    );
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

  void saveMessage(String description, String image, String number_phone, String user) async {
    var huertoapp = _db
        .collection('Messages')
        .document();

    await huertoapp.setData({
      'description': description,
      'image': image,
      'number_phone': number_phone,
      'user': user,
    });
  }
}

