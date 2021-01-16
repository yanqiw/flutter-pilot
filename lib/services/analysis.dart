import 'dart:io';
import 'dart:convert';

import '../constants/ReportType.dart';
import '../models/analysis.dart';

class AnalysisService {
  static final HttpClient httpClient = new HttpClient();

  static Future<Analysis> getAnalysis(String url) async {
    Analysis analysis;
    var uri = Uri.parse(HOST + url);
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      var json = await response.transform(utf8.decoder).join();
      Map data = jsonDecode(json);
      analysis = Analysis.fromJson(data);
    }

    return analysis;
  }
}
