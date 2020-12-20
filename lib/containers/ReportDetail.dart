import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReportDetail extends StatefulWidget {
  final Map<String, String> reportType;

  ReportDetail({this.reportType});

  @override
  _ReportDetailState createState() =>
      _ReportDetailState(reportType: reportType);
}

class _ReportDetailState extends State<ReportDetail> {
  final Map<String, String> reportType;
  final HttpClient httpClient = new HttpClient();

  List<Map<String, String>> _detailData = [];
  String _detailDes = "";
  String _detailTime = "";

  WebViewController _controller;

  _ReportDetailState({this.reportType}) {
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text(
          reportType["name"],
        )),
        //   body: _reportDetail(context),
        // );
        body: new Column(children: [
          new ListTile(
            title: new Text(_detailDes),
          ),
          new Divider(),
          new ListTile(
            title: new Text(_detailTime),
          ),
          new Divider(),
          new Expanded(child: _reportDetail(context))
        ]));
  }

  Widget _reportDetail(BuildContext context) {
    return new ListView.builder(
      itemCount: _detailData.length * 2,
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();
        final index = i ~/ 2;
        return _buildRow(_detailData[index], context);
      },
    );
  }

  Widget _buildRow(item, BuildContext context) {
    List<String> detail = (item["msg"] as String).split('|');
    List<Widget> line = [];

    detail.forEach((element) {
      if (element.length > 0) line.add(new ListTile(title: new Text(element)));
    });

    return new ListTile(
      title: new Column(children: line),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return new Scaffold(
            appBar: new AppBar(title: new Text("详情")),
            body: new Center(
                child: WebView(
              initialUrl: (item["url"] as String).replaceFirst("http", "https"),
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller = webViewController;
              },
            )),
          );
        }));
      },
    );
  }

  fetchData() async {
    var uri = Uri.parse(reportType["url"]);
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      var json = await response.transform(utf8.decoder).join();
      var data = jsonDecode(json);
      if (!mounted) return;

      setState(() {
        _detailData.clear();
        (data["resultList"] as List).forEach((element) {
          _detailData.add({
            "msg": element["msg"] as String,
            "url": element["url"] as String
          });
        });
        _detailDes = data["description"];
        _detailTime = data["generateTime"];
      });
    } else {
      if (!mounted) return;

      setState(() {
        _detailData = [];
        _detailDes = "Error";
        _detailTime = "Error";
      });
    }
  }
}
