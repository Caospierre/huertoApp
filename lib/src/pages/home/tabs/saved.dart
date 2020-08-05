import 'package:flutter/material.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/src/widgets/home/publication_card.dart';
import 'package:huerto_app/utils/colors.dart';

// ignore: must_be_immutable
class SavedPage extends StatelessWidget {
  final Stream<List<PublicationModel>> publicationStream;

  SavedPage(this.publicationStream) {}

  bool isOddNumber(int number) {
    return number % 2 == 0 ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    final body = SingleChildScrollView(
        child: StreamBuilder<List<PublicationModel>>(
      stream: this.publicationStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print(snapshot);
          return Center(child: CircularProgressIndicator());
        } else {}
        print("" + snapshot.data.toString());

        return Stack(
          alignment: Alignment.center,
          children: _buildComponents(snapshot.data),
        );
      },
    ));

    return body;
  }

  void addCrowd() {
    print('data');
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
    list.forEach((publication) {
      int index = list.indexOf(publication);
      bool isOddNum = isOddNumber(index);
      isOddNum ? rightSide.add(publication) : leftSide.add(publication);
    });
    return Row(
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
