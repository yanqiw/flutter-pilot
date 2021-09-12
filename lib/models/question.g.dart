// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) {
  return Question(
    key: json['key'] as String,
    link: json['link'] as String,
    zhihuLink: json['zhihuLink'] as String,
    parentLink: json['parentLink'] as String,
  );
}

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'key': instance.key,
      'link': instance.link,
      'zhihuLink': instance.zhihuLink,
      'parentLink': instance.parentLink,
    };
