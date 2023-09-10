import 'package:json_annotation/json_annotation.dart' show JsonSerializable;

part 'Comment.g.dart';

@JsonSerializable()
class Comment {
  int? id;
  int? likes;
  int? dislikes;
  String? text;
  int? rate;

  Comment({this.id, this.likes, this.dislikes, this.text, this.rate});

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
