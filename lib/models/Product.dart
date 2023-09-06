import 'package:json_annotation/json_annotation.dart' show JsonSerializable;

@JsonSerializable()
class Product {
  int? id;

  Product({this.id});

  factory Product.fromJson(Map<String, dynamic> json) =>
      Product(id: json["id"]);

  Map<String, dynamic> toJson() => {"product_id": id};
}
