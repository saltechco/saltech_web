import 'package:json_annotation/json_annotation.dart' show JsonSerializable;

part 'Product.g.dart';

@JsonSerializable()
class Product {
  int? id;

  Product({this.id});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
