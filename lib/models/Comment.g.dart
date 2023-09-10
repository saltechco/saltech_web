// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as int?,
      likes: json['likes'] as int?,
      dislikes: json['dislikes'] as int?,
      text: json['text'] as String?,
      rate: json['rate'] as int?,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'likes': instance.likes,
      'dislikes': instance.dislikes,
      'text': instance.text,
      'rate': instance.rate,
    };
