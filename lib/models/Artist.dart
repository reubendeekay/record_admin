import 'package:record_admin/models/Album.dart';
import 'package:record_admin/models/Media.dart';

import 'package:json_annotation/json_annotation.dart';

import 'Track.dart';

part 'Artist.g.dart';

@JsonSerializable()
class Artist {
  final int id;
  final String name;
  final String content;
  final Media media;
  final String designation;
  final List<Track> tracks;
  final List<Album> albums;
  Artist(
      {this.id,
      this.name,
      this.content,
      this.media,
      this.designation,
      this.albums,
      this.tracks});
  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistToJson(this);
}
