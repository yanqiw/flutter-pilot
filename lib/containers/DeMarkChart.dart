import 'dart:ffi';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DeMarkChart extends StatefulWidget {
  final Map<String, String> reportType;
  DeMarkChart({this.reportType});

  @override
  _DeMarkChartState createState() => _DeMarkChartState(reportType: reportType);
}

class _DeMarkChartState extends State<DeMarkChart> {
  final HttpClient httpClient = new HttpClient();

  final Map<String, String> reportType;
  final bool animate;
  String _stockNumber = "000002";
  String _startDate = '2020-10-01';
  List<charts.Series> _seriesList;

  _DeMarkChartState({this.reportType, this.animate}) {
    _seriesList = _createLineData({});
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
            title: new Text("股票"),
          ),
          new Divider(),
          new ListTile(
            title: new Text("开始日期"),
          ),
          new Divider(),
          new Container(height: 200.0, child: _reportDetail(context))
        ]));
  }

  Widget _reportDetail(BuildContext context) {
    return new ListView(scrollDirection: Axis.horizontal, children: [
      new Container(
        width: 500,
        child: charts.LineChart(_seriesList, animate: true),
      )
    ]);
  }

  fetchData() async {
    var uri = Uri.parse(reportType["url"]
        .replaceFirst("STOCK_NUM", _stockNumber)
        .replaceFirst("START_DATE", _startDate));
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      var json = await response.transform(utf8.decoder).join();
      var data = jsonDecode(json);
      if (!mounted) return;

      setState(() {
        _seriesList = _createLineData(data);
      });
    } else {
      if (!mounted) return;

      setState(() {});
    }
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createLineData(
      Map<String, dynamic> result) {
    final data = [];
    final List<String> code = result["code"];
    final List<List> kLinePoint = result["k"];
    final List flags = result["flag"];
    for (var point in kLinePoint) {
      data.add(new LinearSales(
          new DateTime.fromMillisecondsSinceEpoch(point[0] as int),
          point[1] as Float));
    }

    return [
      // new charts.Series<LinearSales, DateTime>(
      //   id: 'stock',
      //   colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      //   domainFn: (LinearSales sales, _) => sales.date,
      //   measureFn: (LinearSales sales, _) => sales.r1 as num,
      //   data: data,
      // )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final DateTime date;
  final Float k;

  LinearSales(this.date, this.k);
}
