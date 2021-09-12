import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  String key;
  String link;
  String zhihuLink;
  String parentLink;

  Question({this.key, this.link, this.zhihuLink, this.parentLink});

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}
