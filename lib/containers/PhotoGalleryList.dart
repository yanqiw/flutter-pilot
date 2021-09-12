import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:foo/services/photoGallery.dart';
import 'package:image_picker_saver/image_picker_saver.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  String _detailDes = "";
  String _detailTime = "";
  DateFormat _formatter = new DateFormat('yyyy年MM月dd日');

  // ui control
  bool _showDes = false;

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

  Widget _PhotoGalleryList(BuildContext context) {
    return ListView.builder(
      itemCount: _detailData.length,
      itemBuilder: (context, i) {
        return _buildRow(_detailData[i], context);
      },
    );
  }

  Widget _buildRow(item, BuildContext context) {
    String key = item["key"] as String;
    List<Widget> line = [];

    line.add(Container(child: SectionTitle(title: "$key")));
    bool isImage = item["link"].indexOf(".jpg") > -1;
    print(item["link"]);
    if (isImage) {
      // display image
      line.add(Container(
        child:
            //     WebView(
            //   initialUrl: item["link"],
            // )
            ExtendedImage.network(
          item["link"] ?? DEFAULT_REPORT_IMG,
          height: 600,
          fit: BoxFit.fitWidth,
          cache: true,
        ),
      ));
    }

    line.add(ButtonBar(children: [
      RaisedButton(
          child: Text(isImage ? "下载" : "打开"),
          onPressed: isImage
              ? () {
                  saveNetworkImageToPhoto(item["link"]);
                }
              : () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    Menu report =
                        new Menu(url: item["link"], name: item["key"]);
                    return new PhotoGalleryList(reportType: report);
                  }));
                }),
      RaisedButton(
          child: Text("打开知乎"),
          onPressed: () {
            print("打开知乎");
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

  Future<bool> saveNetworkImageToPhoto(String url,
      {bool useCache: true}) async {
    var data = await getNetworkImageData(url, useCache: useCache);
    var filePath = await ImagePickerSaver.saveFile(fileData: data);
    return filePath != null && filePath != "";
  }

  fetchData() async {
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
        _detailDes = "N/A";
        _detailTime = "N/A";
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
