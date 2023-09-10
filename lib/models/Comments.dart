import 'package:json_annotation/json_annotation.dart' show JsonSerializable;

import "Comment.dart";

part "Comments.g.dart";

@JsonSerializable()
class Comments {
  String? next;
  String? previous;
  List<Comment>? results;

  Comments({this.next, this.previous, this.results});

  factory Comments.fromJson(Map<String, dynamic> json) =>
      _$CommentsFromJson(json);
  Map<String, dynamic> toJson() => _$CommentsToJson(this);
}
