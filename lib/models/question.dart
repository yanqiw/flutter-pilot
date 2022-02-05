import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  String key;
  String link;
  String zhihuLink;
  String parentLink;
  String tag; // gat
  int total; // gat
  String imageRecords;

  Question(
      {this.key,
      this.link,
      this.zhihuLink,
      this.parentLink,
      this.tag,
      this.total,
      this.imageRecords});

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}
