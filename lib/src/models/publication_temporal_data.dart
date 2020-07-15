import 'package:huerto_app/utils/utils.dart';

class PublicationTemporal {
  int id;
  String photo;
  String name;
  String location = "Solanda";
  String type;
  String date = "a week ago";
  String distance = "5.2km away";
  int priceScale; // 1, 2 or 3
  double rating;
  String description = "El mejor cultivo del año";

  PublicationTemporal(
      this.id, this.photo, this.name, this.type, this.priceScale, this.rating);
}

List<PublicationTemporal> publications = [
  PublicationTemporal(
      1, AvailableImages.tomate, "Tomates", "Pepe Papa", 1, 4.5),
  PublicationTemporal(
      2, AvailableImages.zanahoria, "Zanahorias", "Piro Poro", 2, 5.0),
  PublicationTemporal(
      3, AvailableImages.manzana, "Manzanas", "Lalo Landa", 1, 4.0),
  PublicationTemporal(4, AvailableImages.cafe, "Cafe", "Cafe", 2, 4.5),
];
