import 'dart:io';
import 'dart:convert';

import '../constants/ReportType.dart';
import '../models/menu.dart';

class ConfigService {
  static final HttpClient httpClient = new HttpClient();

  static Future<List<Menu>> getMenu() async {
    List<Menu> menus = [];
    var uri = Uri.parse(MEMU_URL);
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      var json = await response.transform(utf8.decoder).join();
      List data = jsonDecode(json);
      data.forEach((e) => menus.add(Menu.fromJson(e)));
    } else {
      // default backfill
      REPORT_TYPES.forEach((e) => menus.add(Menu.fromJson(e)));
    }
    return menus;
  }
}
