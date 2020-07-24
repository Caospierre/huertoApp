import 'package:flutter/material.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/src/widgets/home/swippable_cards.dart';

// ignore: must_be_immutable
class SearchPage extends StatelessWidget {
  final Stream<List<PublicationModel>> publicationStream;

  SearchPage(this.publicationStream) {}

  @override
  Widget build(BuildContext context) {
    return SwippableCards(this.publicationStream);
  }
}
