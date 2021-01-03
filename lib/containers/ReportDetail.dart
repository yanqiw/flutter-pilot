import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import "../constants/reportType.dart";

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
    return Scaffold(
        appBar: AppBar(
            title: Text(
          reportType["name"],
        )),
        //   body: _reportDetail(context),
        // );
        body: Column(children: [
          ListTile(
            title: Text(_detailDes),
          ),
          Divider(),
          ListTile(
            title: Text(_detailTime),
          ),
          Divider(),
          Expanded(child: _reportDetail(context))
        ]));
  }

  Widget _reportDetail(BuildContext context) {
    return ListView.builder(
      itemCount: _detailData.length * 2,
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();
        final index = i ~/ 2;
        return _buildRow(_detailData[index], context);
      },
    );
  }

  Widget _buildRow(item, BuildContext context) {
    String code = item["code"] as String;
    String name = item["name"] as String;
    List<String> detail = (item["msg"] as String).split('|');
    List<Widget> line = [];

    line.add(ListTile(title: Text("$code | $name")));
    detail.forEach((element) {
      if (element.length > 0) line.add(ListTile(title: Text(element)));
    });
    line.add(ButtonBar(children: [
      RaisedButton(
          child: Text("DeMark 回溯"),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(title: Text("DeMark 回溯")),
                  body: Center(
                      child: WebView(
                    initialUrl: DEMARK_CHART_URL.replaceFirst(STOCK_NUM, code),
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

    return ListTile(
      title: Column(children: line),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text("详情")),
            body: Center(
                child: WebView(
              initialUrl: (item["url"] as String).replaceFirst("http", "https"),
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller = webViewController;
              },
            )),
            bottomNavigationBar: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.arrow_back), title: Text("返回")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.arrow_forward), title: Text("前进")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.close), title: Text("关闭"))
                ],
                onTap: (index) {
                  switch (index) {
                    case 0:
                      _controller.goBack();
                      break;
                    case 1:
                      _controller.goForward();
                      break;
                    case 2:
                      Navigator.pop(context);
                      break;
                    default:
                  }
                }),
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
            "name": element["name"] as String,
            "code": element["code"] as String,
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

class WebViewNavBar extends StatelessWidget {
  const WebViewNavBar({
    Key key,
    @required WebViewController controller,
  })  : _controller = controller,
        super(key: key);

  final WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_back), title: Text("返回")),
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_forward), title: Text("前进")),
          BottomNavigationBarItem(icon: Icon(Icons.close), title: Text("关闭"))
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              _controller.goBack();
              break;
            case 1:
              _controller.goForward();
              break;
            case 2:
              Navigator.pop(context);
              break;
            default:
          }
        });
  }
}
