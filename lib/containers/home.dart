import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';

import '../styles/Themes.dart';
import '../services/config.dart';
import '../models/menu.dart';
import './ReportDetail.dart';
import './BackTracking.dart';
import './DeMarkReport.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Menu> _reportTypes;

  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _smallerFont = const TextStyle(fontSize: 14.0);

  _HomeState() {
    List<Menu> menu = ConfigService.getLocalMenu();
    _reportTypes = menu;

    // fetch backend
    fetchMenu();

    // start h5 app server
    _startService();
  }

  fetchMenu() async {
    List<Menu> menu = await ConfigService.getMenu();
    setState(() {
      _reportTypes = menu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('希望 2.0'),
      ),
      body: _reportType(context),
    );
  }

  Widget _reportType(BuildContext context) {
    if (_reportTypes == null) {
      return Container(child: Text('loading'));
    }

    return GroupedListView(
      // itemCount: _reportTypes.length * 2,
      padding: const EdgeInsets.all(16.0),
      // 对于每个建议的单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
      // 在偶数行，该函数会为单词对添加一个ListTile row.
      // 在奇数行，该函数会添加一个分割线widget，来分隔相邻的词对。
      // 注意，在小屏幕上，分割线看起来可能比较吃力。
      itemBuilder: (context, element) {
        return _buildRow(element, context);
      },
      groupBy: (element) => element.group,
      groupSeparatorBuilder: (groupByValue) => Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(WHITE_SPACE_M),
        child: Text(
          groupByValue,
          style: _biggerFont,
        ),
      ),
      elements: _reportTypes,
    );
  }

  Widget _buildRow(Menu reportType, BuildContext context) {
    return InkWell(
      child: Card(
          child: Column(children: [
        Image.network(
          reportType.image ?? DEFAULT_REPORT_IMG,
          fit: BoxFit.cover,
          height: 200,
          width: double.infinity,
        ),
        Container(
            padding: EdgeInsets.all(WHITE_SPACE_M),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(), // fill width
                Text(
                  reportType.name,
                  style: _biggerFont,
                ),
                Text(
                  reportType.description ?? '',
                  style: _smallerFont,
                ),
              ],
            )),
      ])),
      onTap: () {
        router(reportType, context);
      },
    );
  }

  _startService() async {
    final server = Jaguar(address: "127.0.0.1", port: 8008);
    server.addRoute(serveFlutterAssets());
    await server.serve(logRequests: true);
  }

  void router(Menu reportType, BuildContext context) {
    switch (reportType.router) {
      case "BackTracking":
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return new BackTracking(reportType: reportType);
        }));
        break;
      case "ReportDetail":
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return new ReportDetail(reportType: reportType);
        }));
        break;
      case "DeMarkReport":
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return new DeMarkReport(reportType: reportType);
        }));
        break;
      default:
    }
  }
}
