// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Comments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comments _$CommentsFromJson(Map<String, dynamic> json) => Comments(
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommentsToJson(Comments instance) => <String, dynamic>{
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };
