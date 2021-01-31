import 'package:json_annotation/json_annotation.dart';

part 'menu.g.dart';

@JsonSerializable()
class Menu {
  String id;
  int version;
  String group;
  String name;
  String router;
  String url;
  String html;
  String image;
  String description;

  Menu(
      {this.name,
      this.group,
      this.router,
      this.url,
      this.html,
      this.image,
      this.description,
      this.id,
      this.version});

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);
  Map<String, dynamic> toJson() => _$MenuToJson(this);
}
