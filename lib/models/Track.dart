import 'package:json_annotation/json_annotation.dart';

part 'Track.g.dart';

@JsonSerializable(explicitToJson: true)
class Track {
  final int id;
  String title;
  String content;
  String url;
  String cover;
  String localPath;
  String time;
  Track(
    this.id,
    this.title,
    this.content,
    this.url,
    this.cover,
    this.localPath,
    this.time,
  );

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);

  Map<String, dynamic> toJson() => _$TrackToJson(this);
}
