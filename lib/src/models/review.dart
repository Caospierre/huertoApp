import 'publication_temporal_data.dart';

class Review {
  int id = 0;
  int publicationId;
  String publicationPhoto;
  String publicationName;
  String location = "Solanda";
  String publicationType;
  String date = "a week ago";
  double rating;
  String content;

  Review(this.publicationId, this.publicationPhoto, this.publicationName,
      this.publicationType, this.rating, this.content);
}

List<Review> reviews = [
  Review(
    publications[0].id,
    publications[0].photo,
    publications[0].name,
    publications[0].type,
    5.0,
    "El tomate crece en la sierra.",
  ),
  Review(
    publications[0].id,
    publications[1].photo,
    publications[1].name,
    publications[1].type,
    4.9,
    "La zanohorias protejen el ❤️",
  )
];
