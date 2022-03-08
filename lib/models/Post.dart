import 'package:record_admin/models/Comment.dart';
import 'package:record_admin/models/User.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Media.dart';
part 'Post.g.dart';

@JsonSerializable(explicitToJson: true)
class Post {
  final int id;
  final String title;
  final String content;
  final Media media;
  final UserModel author;
  final String date;
  final List<Comment> comments;
  final String commentCount;

  Post(
    this.id,
    this.title,
    this.content,
    this.author,
    this.media,
    this.comments,
    this.date,
    this.commentCount,
  );
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
