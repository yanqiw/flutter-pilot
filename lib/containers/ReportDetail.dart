import 'dart:io';

import 'package:foo/models/analysis.dart';
import 'package:foo/models/menu.dart';
import 'package:foo/services/analysis.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants/ReportType.dart';
import "../presentation/WebViewNavBar.dart";
import '../styles/Themes.dart';

class ReportDetail extends StatefulWidget {
  final Menu reportType;

  ReportDetail({this.reportType});

  @override
  _ReportDetailState createState() =>
      _ReportDetailState(reportType: reportType);
}

class _ReportDetailState extends State<ReportDetail>
    implements WebViewNavBarDelegate {
  final Menu reportType;
  final HttpClient httpClient = new HttpClient();

  List<Map<String, dynamic>> _detailData = [];
  String _detailDes = "";
  String _detailTime = "";
  DateFormat _formatter = new DateFormat('yyyy年MM月dd日');

  // ui control
  bool _showDes = false;

  WebViewController controller;

  _ReportDetailState({this.reportType}) {
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          reportType.name,
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
                  IconButton(
                      icon: _showDes
                          ? Icon(Icons.arrow_circle_down)
                          : Icon(Icons.arrow_circle_up),
                      onPressed: () {
                        setState(() {
                          _showDes = !_showDes;
                        });
                      }),
                  _showDes ? Text(_detailDes) : Container(),
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
            "BS: ${element["setup"] > 0 ? _formatter.format(DateTime.fromMillisecondsSinceEpoch(element["setup"])) : '未出现'} (${element['setupNumber']})",
            style: TextStyle(
                color: element['setupNumber'] >= 9
                    ? Colors.redAccent
                    : Colors.black),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.start)
      ]));
      line.add(Row(children: [
        Text(
            "BC: ${element["countdown"] > 0 ? _formatter.format(DateTime.fromMillisecondsSinceEpoch(element["countdown"])) : '未出现'} (${element['countdownNumber']})",
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
                        controller = webViewController;
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
                  bottomNavigationBar: WebViewNavBar(delegateWidget: this),
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
                      controller = webViewController;
                    },
                  )),
                  bottomNavigationBar: WebViewNavBar(delegateWidget: this),
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
    Analysis data = await AnalysisService.getAnalysis(reportType.url);
    if (!mounted) return;
    if (data != null) {
      setState(() {
        _detailData.clear();
        data.resultList.forEach((element) {
          _detailData.add({
            "msg": element["msg"] as String,
            "name": element["name"] as String,
            "code": element["code"] as String,
            "url": element["url"] as String,
            "data": element["data"] != null ? element["data"]["flag"] : [],
          });
        });
        _detailData.sort((left, right) {
          if (left['data'] is List &&
              right['data'] is List &&
              (right['data'] as List).length > 0 &&
              (left['data'] as List).length > 0) {
            return (right['data'] as List)
                .last["countdown"]
                .compareTo((left['data'] as List).last["countdown"]);
          } else {
            return 1;
          }
        });
        _detailDes = data.description;
        _detailTime = data.generateTime;
      });
    } else {
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
