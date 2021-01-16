import 'package:flutter/material.dart';

import '../services/config.dart';
import '../models/menu.dart';
import './ReportDetail.dart';
import './BackTracking.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Menu> _reportTypes;

  final _biggerFont = const TextStyle(fontSize: 18.0);

  _HomeState() {
    fetchMenu();
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
        title: new Text('股票分析'),
      ),
      body: _reportType(context),
    );
  }

  Widget _reportType(BuildContext context) {
    if (_reportTypes == null) {
      return Container(child: Text('loading'));
    }

    return ListView.builder(
        itemCount: _reportTypes.length * 2,
        padding: const EdgeInsets.all(16.0),
        // 对于每个建议的单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
        // 在偶数行，该函数会为单词对添加一个ListTile row.
        // 在奇数行，该函数会添加一个分割线widget，来分隔相邻的词对。
        // 注意，在小屏幕上，分割线看起来可能比较吃力。
        itemBuilder: (context, i) {
          // 在每一列之前，添加一个1像素高的分隔线widget
          if (i.isOdd) return new Divider();
          // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5
          // 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
          final index = i ~/ 2;
          // // 如果是建议列表中最后一个单词对
          if (index >= _reportTypes.length) {
            return new Divider();
          }

          var item = _reportTypes[index];
          return _buildRow(item, context);
        });
  }

  Widget _buildRow(Menu reportType, BuildContext context) {
    return new ListTile(
      title: new Text(
        reportType.name,
        style: _biggerFont,
      ),
      onTap: () {
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
          default:
        }
      },
    );
  }
}
