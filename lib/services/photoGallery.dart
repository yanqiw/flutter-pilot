import 'dart:io';
import 'dart:convert';

import 'package:foo/models/question.dart';

import '../constants/ReportType.dart';
import '../models/analysis.dart';

class PhotoGalleryService {
  static final HttpClient httpClient = new HttpClient();

  static Future<List<Question>> getList(String url) async {
    List<Question> keyList = [];
    var uri =
        Uri.parse((url.indexOf("http") == 0 ? "" : PHOTO_GALLERY_HOST) + url);
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      var json = await response.transform(utf8.decoder).join();
      List data = jsonDecode(json);
      for (var item in data) {
        keyList.add(Question.fromJson(item));
      }
    }

    return keyList;
  }

  static Future<bool> downloadDetail(String url) async {
    if (url.indexOf("http") == -1) {
      return false;
    }

    var uri = Uri.parse(PHOTO_GALLERY_DOWNLOAD_URL + url);
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      return true;
    }

    return false;
  }
}
