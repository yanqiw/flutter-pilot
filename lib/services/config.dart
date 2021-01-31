import 'dart:io';
import 'dart:convert';

import '../constants/ReportType.dart';
import '../models/menu.dart';

class ConfigService {
  static final HttpClient httpClient = new HttpClient();

  static List<Menu> getLocalMenu() {
    List<Menu> menus = [];
    REPORT_TYPES.forEach((e) => menus.add(Menu.fromJson(e)));
    return menus;
  }

  static Future<List<Menu>> getMenu() async {
    List<Menu> menus = [];
    var uri = Uri.parse(MEMU_URL);
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    // default
    REPORT_TYPES.forEach((e) => menus.add(Menu.fromJson(e)));

    if (response.statusCode == HttpStatus.ok) {
      var json = await response.transform(utf8.decoder).join();
      List data = jsonDecode(json);
      // merge cloud config
      data.forEach((e) {
        var item = Menu.fromJson(e);
        var localItem = menus.firstWhere((element) => element.id == item.id,
            orElse: () => null);
        // if cloud config version higher than local, replace the item
        if (localItem != null &&
            localItem.version != null &&
            item.version != null &&
            localItem.version < item.version) {
          localItem.name = item.name;
          localItem.router = item.router;
          localItem.url = item.url;
          localItem.html = item.html;
          localItem.image = item.image;
          localItem.description = item.description;
        }

        // add new item from cloud
        if (item.id != null && localItem == null) {
          menus.add(item);
        }
      });
    }
    return menus;
  }
}
