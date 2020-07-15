import 'package:flutter/material.dart';
import 'package:huerto_app/src/widgets/home/publication_card.dart';
import 'package:huerto_app/src/models/publication_temporal_data.dart';

class SavedPage extends StatelessWidget {
  bool isOddNumber(int number) {
    return number % 2 == 0 ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    // final _body = CustomScrollView(
    //   primary: false,
    //   slivers: <Widget>[
    //     SliverPadding(
    //       padding: EdgeInsets.only(
    //         left: 20.0,
    //         right: 20.0,
    //         top: 40.0,
    //         bottom: 40.0,
    //       ),
    //       sliver: SliverGrid.count(
    //         childAspectRatio: 0.6,
    //         crossAxisCount: 2,
    //         mainAxisSpacing: 10.0,
    //         crossAxisSpacing: 10.0,
    //         children: publications.map(
    //           (publication) {
    //             int index = publications.indexOf(publication);
    //             bool isOddNum = isOddNumber(index);
    //             if (isOddNum) {
    //               return Column(
    //                 children: <Widget>[
    //                   SizedBox(
    //                     height: 50.0,
    //                   ),
    //                   PublicationCard(publication: publication)
    //                 ],
    //               );
    //             } else {
    //               return PublicationCard(publication: publication);
    //             }
    //           },
    //         ).toList(),
    //       ),
    //     )
    //   ],
    // );

    final _body2 = SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: 40.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              PublicationCard(publication: publications[0]),
              PublicationCard(publication: publications[1]),
            ],
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: 70.0,
              ),
              PublicationCard(publication: publications[2]),
              PublicationCard(publication: publications[3]),
            ],
          ),
        ],
      ),
    );

    return _body2;
  }

  Widget buildList() {
    List<PublicationTemporal> leftSide = [];
    List<PublicationTemporal> rightSide = [];
    publications.forEach((publication) {
      int index = publications.indexOf(publication);
      bool isOddNum = isOddNumber(index);
      isOddNum ? rightSide.add(publication) : leftSide.add(publication);
    });

    return Row(
      children: <Widget>[
        Column(
          children: leftSide
              .map((res) => PublicationCard(publication: null))
              .toList(),
        ),
        Column(
          children: rightSide.map((res) {
            return Column(
              children: <Widget>[
                SizedBox(height: 70.0),
                PublicationCard(publication: res),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
