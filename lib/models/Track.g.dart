// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Track _$TrackFromJson(Map<String, dynamic> json) {
  return Track(
    json['id'] as int,
    json['title'] as String,
    json['content'] as String,
    json['url'] as String,
    json['cover'] as String,
    json['localPath'] as String,
    json['time'] as String,
  );
}

Map<String, dynamic> _$TrackToJson(Track instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'url': instance.url,
      'cover': instance.cover,
      'localPath': instance.localPath,
      'time': instance.time,
    };
