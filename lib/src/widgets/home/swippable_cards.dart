import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/src/services/init_services.dart';
import 'package:huerto_app/utils/utils.dart';
import 'package:huerto_app/src/widgets/home/publication_card_big.dart';

// ignore: must_be_immutable
class SwippableCards extends StatefulWidget {
  final Stream<List<PublicationModel>> publicationStream;

  SwippableCards(this.publicationStream) {}

  @override
  _SwippableCardsState createState() =>
      _SwippableCardsState(this.publicationStream);
}

class _SwippableCardsState extends State<SwippableCards> {
  List<Widget> cardList;

  List<PublicationModel> _publicationsCopy;

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
    return Center(
        child: StreamBuilder<List<PublicationModel>>(
      stream: this.widget.publicationStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print(snapshot);
          return Center(child: CircularProgressIndicator());
        } else {}
        print("" + snapshot.data.toString());
        return Stack(
          alignment: Alignment.center,
          children: _getSwipeCards(snapshot.data),
        );
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
      onPressed: () {},
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
}
