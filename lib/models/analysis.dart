import 'package:json_annotation/json_annotation.dart';

part 'analysis.g.dart';

@JsonSerializable()
class Analysis {
  String description;
  String generateTime;
  List<Map> resultList;
  List<Map> items;

  Analysis({this.description, this.generateTime, this.resultList});

  factory Analysis.fromJson(Map<String, dynamic> json) =>
      _$AnalysisFromJson(json);
  Map<String, dynamic> toJson() => _$AnalysisToJson(this);
}
