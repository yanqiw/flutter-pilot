import 'dart:io';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants/ReportType.dart';
import "../presentation/WebViewNavBar.dart";
import '../styles/Themes.dart';

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

  List<Map<String, dynamic>> _detailData = [];
  String _detailDes = "";
  String _detailTime = "";
  DateFormat formatter = new DateFormat('yyyy年MM月dd日');

  WebViewController _controller;

  _ReportDetailState({this.reportType}) {
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          reportType["name"],
        )),
        //   body: _reportDetail(context),
        // );
        body: Column(children: [
          Container(height: WHITE_SPACE_L),
          Expanded(child: _reportDetail(context)),
          Divider(),
          Card(
            margin: EdgeInsets.all(WHITE_SPACE_S),
            clipBehavior: Clip.antiAlias,
            child: Container(
                padding: EdgeInsets.all(WHITE_SPACE_M),
                child: Column(children: [
                  Text(_detailDes),
                  Text('更新时间: ' + _detailTime)
                ])),
          ),
        ]));
  }

  Widget _reportDetail(BuildContext context) {
    return ListView.builder(
      itemCount: _detailData.length,
      itemBuilder: (context, i) {
        return _buildRow(_detailData[i], context);
      },
    );
  }

  Widget _buildRow(item, BuildContext context) {
    String code = item["code"] as String;
    String name = item["name"] as String;
    List<dynamic> detail = (item["data"] as List);
    List<Widget> line = [];

    line.add(Container(child: SectionTitle(title: "$name [${code.trim()}]")));
    line.add(Divider());
    detail.forEach((element) {
      line.add(Row(children: [
        Text(
            "BS: ${element["setup"] > 0 ? formatter.format(DateTime.fromMillisecondsSinceEpoch(element["setup"])) : '未出现'} (${element['setupNumber']})",
            style: TextStyle(
                color: element['setupNumber'] >= 9
                    ? Colors.redAccent
                    : Colors.black),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.start)
      ]));
      line.add(Row(children: [
        Text(
            "BC: ${element["countdown"] > 0 ? formatter.format(DateTime.fromMillisecondsSinceEpoch(element["countdown"])) : '未出现'} (${element['countdownNumber']})",
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.start)
      ]));
      line.add(Row(children: [
        Container(
          height: WHITE_SPACE_S,
        )
      ]));
    });

    line.add(ButtonBar(children: [
      RaisedButton(
          child: Text("DeMark 回溯"),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                var isLoading = false;
                return Scaffold(
                  appBar: AppBar(title: Text("DeMark 回溯")),
                  body: Stack(children: [
                    WebView(
                      initialUrl:
                          DEMARK_CHART_URL.replaceFirst(STOCK_NUM, code),
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        _controller = webViewController;
                      },
                      navigationDelegate: (NavigationRequest request) {
                        setState(() {
                          isLoading = true; // 开始访问页面，更新状态
                        });
                        return NavigationDecision.navigate;
                      },
                      onPageFinished: (String url) {
                        setState(() {
                          isLoading = false; // 页面加载完成，更新状态
                        });
                      },
                    ),
                    isLoading
                        ? Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container(),
                  ]),
                  bottomNavigationBar: WebViewNavBar(controller: _controller),
                );
              },
            ));
          }),
      RaisedButton(
          child: Text("股票详情"),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(title: Text("详情")),
                  body: Center(
                      child: WebView(
                    initialUrl:
                        (item["url"] as String).replaceFirst("http", "https"),
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller = webViewController;
                    },
                  )),
                  bottomNavigationBar: WebViewNavBar(controller: _controller),
                );
              },
            ));
          })
    ]));

    return Container(
      child: Card(
        child: Container(
            padding: EdgeInsets.all(WHITE_SPACE_M),
            child: Column(children: line)),
      ),
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
            "name": element["name"] as String,
            "code": element["code"] as String,
            "url": element["url"] as String,
            "data": element["data"] != null ? element["data"]["flag"] : [],
          });
        });
        // _detailData.sort((left, right) =>
        //     (left["data"] as List).last["setup"] >
        //     (right["data"] as List).last["setup"]);

        _detailData.sort((left, right) {
          if (left['data'] is List &&
              right['data'] is List &&
              (right['data'] as List).length > 0 &&
              (left['data'] as List).length > 0) {
            return (right['data'] as List)
                .last["setup"]
                .compareTo((left['data'] as List).last["setup"]);
          } else {
            return 1;
          }
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

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: Theme.of(context).textTheme.subtitle1),
      ),
    );
  }
}
