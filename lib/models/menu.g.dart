// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Menu _$MenuFromJson(Map<String, dynamic> json) {
  return Menu(
    name: json['name'] as String,
    order: json['order'] as int,
    group: json['group'] as int,
    groupName: json['groupName'] as String,
    router: json['router'] as String,
    url: json['url'] as String,
    html: json['html'] as String,
    image: json['image'] as String,
    description: json['description'] as String,
    id: json['id'] as String,
    version: json['version'] as int,
  );
}

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
      'id': instance.id,
      'version': instance.version,
      'order': instance.order,
      'group': instance.group,
      'groupName': instance.groupName,
      'name': instance.name,
      'router': instance.router,
      'url': instance.url,
      'html': instance.html,
      'image': instance.image,
      'description': instance.description,
    };
