import 'dart:convert';

import 'package:json_annotation/json_annotation.dart' show JsonSerializable;

@JsonSerializable()
class Comment {
  int? id;
  int? likes;
  int? dislikes;
  String? text;
  int? rank;

  Comment({this.id, this.likes, this.dislikes, this.text, this.rank});

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
      id: json["id"],
      likes: json["likes"],
      dislikes: json["dislikes"],
      text: json["text"],
      rank: json["rank"]);
  Map<String, dynamic> toJson() => {
        "id": id,
        "likes": likes,
        "dislikes": dislikes,
        "text": text,
        "rank": rank
      };
}

List<Comment> commentFromJson(String str) =>
    List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

String commentToJson(List<Comment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
