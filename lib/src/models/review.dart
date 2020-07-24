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
    1,
    "assets/images/zanahoria.jpg",
    "test",
    "",
    5.0,
    "El tomate crece en la sierra.",
  ),
  Review(
    1,
    "assets/images/zanahoria.jpg",
    "test",
    "",
    5.0,
    "El tomate crece en la sierra.",
  ),
];
