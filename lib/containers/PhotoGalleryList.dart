import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foo/services/photoGallery.dart';
// import 'package:image_picker_saver/image_picker_saver.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import "../presentation/WebViewNavBar.dart";
import '../styles/Themes.dart';
import '../models/menu.dart';

class PhotoGalleryList extends StatefulWidget {
  final Menu reportType;

  PhotoGalleryList({this.reportType});

  @override
  _PhotoGalleryListState createState() =>
      _PhotoGalleryListState(reportType: reportType);
}

class _PhotoGalleryListState extends State<PhotoGalleryList>
    implements WebViewNavBarDelegate {
  final Menu reportType;
  final HttpClient httpClient = new HttpClient();

  List<Map<String, dynamic>> _detailData = [];
  String _detailUrl = "";

  // ui control
  bool _showDes = false;
  TextEditingController _textController = TextEditingController();
  WebViewController controller;

  _PhotoGalleryListState({this.reportType}) {
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          reportType.name,
        )),
        //   body: _PhotoGalleryList(context),
        // );
        body: Column(children: [
          Container(height: WHITE_SPACE_L),
          Expanded(child: _PhotoGalleryList(context)),
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
                  _showDes
                      ? Container(
                          child: Column(
                          children: [
                            TextField(
                              controller: _textController,
                              onChanged: (v) {
                                _detailUrl = v;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.link),
                                suffixIcon: IconButton(
                                  onPressed: _textController.clear,
                                  icon: Icon(Icons.clear),
                                ),
                              ),
                            ),
                            ElevatedButton(
                                child: Text("下载"),
                                onPressed: () {
                                  downloadDetail(_detailUrl);
                                })
                          ],
                        ))
                      : Container(),
                ])),
          ),
        ]));
  }

  Widget _PhotoGalleryList(BuildContext context) {
    return ListView.builder(
      itemCount: _detailData.length,
      itemBuilder: (context, i) {
        return _buildRow(_detailData[i], context, i);
      },
    );
  }

  Widget _buildRow(item, BuildContext context, int index) {
    String key = item["key"] as String;
    key = key.replaceFirst("resources/zhihu-images/", "");
    List<Widget> line = [];

    line.add(Container(child: SectionTitle(title: "$key")));
    bool isImage = item["link"].indexOf(".jpg") > -1;
    bool isZhihuLink = item["zhihuLink"] != "";
    bool isAnswer = !isImage && (item["zhihuLink"].indexOf("answer") > -1);

    if (isImage) {
      // display image
      line.add(Container(
        child: ExtendedImage.network(
          item["link"] ?? DEFAULT_REPORT_IMG,
          height: 550,
          fit: BoxFit.fitWidth,
          cache: true,
        ),
      ));
    }

    if (isAnswer) {
      if (null == item["thumb"]) {
        fetchFirstImage(item["link"] as String, index);
      }
      if (null != item["count"]) {
        line.add(Container(
          child: Text("共 " + item["count"] + " 张"),
        ));
      }
      line.add(Container(
        child: ExtendedImage.network(
          item["thumb"] ?? DEFAULT_REPORT_IMG,
          height: 550,
          fit: BoxFit.fitWidth,
          cache: true,
        ),
      ));
    }

    // action bar
    line.add(ButtonBar(children: [
      ElevatedButton(
          child: Text(isImage ? "下载" : "打开"),
          onPressed: isImage
              ? () {
                  saveNetworkImageToPhoto(item["link"]);
                }
              : () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    Menu report = new Menu(url: item["link"], name: key);
                    return new PhotoGalleryList(reportType: report);
                  }));
                }),
      ElevatedButton(
          child: Text(isZhihuLink ? "打开知乎" : "无链接"),
          onPressed: isZhihuLink
              ? () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    var isLoading = false;
                    return Scaffold(
                      appBar: AppBar(title: Text("知乎")),
                      body: Stack(children: [
                        WebView(
                          initialUrl: item["zhihuLink"],
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated:
                              (WebViewController webViewController) {
                            controller = webViewController;
                          },
                          navigationDelegate: (NavigationRequest request) {
                            print(request.url);
                            if (request.url.indexOf("http") == -1) {
                              _launchURL(request.url);
                            }
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
                  }));
                }
              : () {})
    ]));

    return Container(
      child: Card(
        child: Container(
            padding: EdgeInsets.all(WHITE_SPACE_M),
            child: Column(children: line)),
      ),
    );
  }

  Future<bool> saveNetworkImageToPhoto(String url,
      {bool useCache: true}) async {
    // var data = await getNetworkImageData(url, useCache: useCache);
    // var filePath = await ImagePickerSaver.saveFile(fileData: data);
    // return filePath != null && filePath != "";
    return false;
  }

  void downloadDetail(url) async {
    bool res = await PhotoGalleryService.downloadDetail(url);
    if (res) {
      Fluttertoast.showToast(msg: "成功", backgroundColor: Colors.green);
    } else {
      Fluttertoast.showToast(msg: "失败", backgroundColor: Colors.red);
    }
  }

  void fetchData() async {
    List data = await PhotoGalleryService.getList(reportType.url);
    if (!mounted) return;
    if (data != null) {
      setState(() {
        _detailData.clear();
        data.forEach((element) {
          _detailData.add({
            "key": element.key as String,
            "link": element.link as String,
            "zhihuLink": element.zhihuLink as String,
            "parentLink": element.parentLink as String,
          });
        });
      });
    } else {
      setState(() {
        _detailData = [];
      });
    }
  }

  void fetchFirstImage(String url, int index) async {
    List data = await PhotoGalleryService.getList(url);
    if (!mounted) return;
    if (data != null && data.length > 0) {
      setState(() {
        _detailData[index]["thumb"] = data[0].link as String;
        _detailData[index]["count"] = data.length.toString();
      });
    }
  }

  void _launchURL(url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
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
        child: Text(title, style: Theme.of(context).textTheme.headline6),
      ),
    );
  }
}
