import 'dart:convert';

import 'package:json_annotation/json_annotation.dart' show JsonSerializable;

import "Comment.dart";

@JsonSerializable()
class Comments {
  String? next;
  String? previous;
  List<Comment>? results;

  Comments({this.next, this.previous, this.results});

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
      next: json["next"], previous: json["previous"], results: json["results"]);
  Map<String, dynamic> toJson() =>
      {"next": next, "previous": previous, "results": results};
}

List<Comments> commentsFromJson(String str) =>
    List<Comments>.from(json.decode(str).map((x) => Comments.fromJson(x)));

String commentsToJson(List<Comments> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
