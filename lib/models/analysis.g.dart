// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Analysis _$AnalysisFromJson(Map<String, dynamic> json) {
  return Analysis(
    description: json['description'] as String,
    generateTime: json['generateTime'] as String,
    resultList: (json['resultList'] as List)
        ?.map((e) => e as Map<String, dynamic>)
        ?.toList(),
  );
}

Map<String, dynamic> _$AnalysisToJson(Analysis instance) => <String, dynamic>{
      'description': instance.description,
      'generateTime': instance.generateTime,
      'resultList': instance.resultList,
    };
