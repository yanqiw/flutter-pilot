import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:foo/constants/ReportType.dart';
import 'package:intl/intl.dart';

class BackTracking extends StatefulWidget {
  final Map<String, String> reportType;
  BackTracking({this.reportType});

  @override
  _BackTrackingState createState() =>
      _BackTrackingState(reportType: reportType);
}

class _BackTrackingState extends State<BackTracking> {
  final HttpClient httpClient = new HttpClient();

  final Map<String, String> reportType;
  final bool animate;
  String _stockNumber = "000001";
  String _stockName = "平安银行";
  int _backDays = 200;
  DateTime _nowDate = DateTime.now();
  List<charts.Series> _seriesList;

  DateTime _time = DateTime.now();
  Map<String, num> _measures = {"r1": 0, "r2": 0};

  _BackTrackingState({this.reportType, this.animate}) {
    _seriesList = _createLineData({"category": [], "r1": [], "r2": []});
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
          Container(
            padding: EdgeInsets.all(5.0),
            child: new TextField(
              onSubmitted: (value) {
                _stockNumber = value;
                fetchStock();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '股票代码',
              ),
            ),
          ),
          new Divider(),
          new ListTile(
            title: new Text("开始日期"),
          ),
          new ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              new RaisedButton(
                  child: Text('三个月'),
                  onPressed: () {
                    _backDays = 100;
                    fetchData();
                  }),
              new RaisedButton(
                  child: Text('六个月'),
                  onPressed: () {
                    _backDays = 200;
                    fetchData();
                  }),
              new RaisedButton(
                  child: Text('一年'),
                  onPressed: () {
                    _backDays = 365;
                    fetchData();
                  }),
              new RaisedButton(
                  child: Text('三年'),
                  onPressed: () {
                    _backDays = 365 * 3;
                    fetchData();
                  }),
            ],
          ),
          new Divider(),
          new ListTile(
            subtitle: new Text(
                "日期: ${DateFormat('yyyy-MM-dd').format(_time)}\nr1: ${_measures['r1']}\nr2: ${_measures['r2']}"),
            title: new Text("$_stockName | $_stockNumber "),
          ),
          new Divider(),
          new Container(height: 300.0, child: _reportDetail(context))
        ]));
  }

  Widget _reportDetail(BuildContext context) {
    return new ListView(scrollDirection: Axis.horizontal, children: [
      new Container(
        width: (5 * _backDays).toDouble(),
        child: charts.TimeSeriesChart(_seriesList,
            animate: true,
            primaryMeasureAxis: new charts.NumericAxisSpec(
                tickProviderSpec: new charts.BasicNumericTickProviderSpec(
              zeroBound: false,
              desiredTickCount: 10,
            )),
            domainAxis: new charts.DateTimeAxisSpec(
                tickProviderSpec:
                    new charts.DayTickProviderSpec(increments: [10]),
                tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                    day: new charts.TimeFormatterSpec(
                        format: 'd', transitionFormat: 'yyyy-MM-dd'))),
            behaviors: [
              new charts.SeriesLegend()
            ],
            selectionModels: [
              new charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                changedListener: _onSelectionChanged,
              )
            ]),
      )
    ]);
  }

  fetchStock() async {
    var uri =
        Uri.parse(SEARCH_STOCK_URL.replaceFirst("STOCK_NUM", _stockNumber));
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      var json = await response.transform(utf8.decoder).join();
      var data = jsonDecode(json);
      if (!mounted || data['code'] == 100) return;

      setState(() {
        if (data['symbols'].length == 1) {
          _stockName = data['symbols'][0]['name'];
          _stockNumber = data['symbols'][0]['code'];
          fetchData();
        } else {
          _showCupertinoPicker(context, data['symbols']);
        }
      });
    } else {
      if (!mounted) return;
      setState(() {});
    }
  }

  fetchData() async {
    String startDate = DateFormat("yyyy-MM-dd")
        .format(_nowDate.subtract(new Duration(days: _backDays)));
    var uri = Uri.parse(reportType["url"]
        .replaceFirst("STOCK_NUM", _stockNumber)
        .replaceFirst("START_DATE", startDate));
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      var json = await response.transform(utf8.decoder).join();
      var data = jsonDecode(json);
      if (!mounted || data['code'] == 100) return;

      setState(() {
        _seriesList = _createLineData(data);
      });
    } else {
      if (!mounted) return;

      setState(() {});
    }
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, DateTime>> _createLineData(
      Map<String, dynamic> result) {
    final List<LinearSales> data = [];
    final List<LinearSales> data2 = [];
    final List dates = result["category"];
    final List r1 = result["r1"];
    final List r2 = result["r2"];
    int counter = 0;

    for (var date in dates) {
      List<String> _date = date.split('-');
      data.add(new LinearSales(
          new DateTime(
              int.parse(_date[0]), int.parse(_date[1]), int.parse(_date[2])),
          r1[counter].toDouble(),
          r2[counter].toDouble()));
      counter += 1;
    }

    return [
      new charts.Series<LinearSales, DateTime>(
        id: 'r1',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.date,
        measureFn: (LinearSales sales, _) => sales.r1,
        data: data,
      ),
      new charts.Series<LinearSales, DateTime>(
        id: 'r2',
        colorFn: (_, __) => charts.MaterialPalette.black,
        domainFn: (LinearSales sales, _) => sales.date,
        measureFn: (LinearSales sales, _) => sales.r2,
        data: data,
      )
    ];
  }

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime time;
    final measures = <String, num>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.date;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] =
            datumPair.datum.getProp(datumPair.series.displayName);
      });
    }

    // Request a build.
    setState(() {
      _time = time;
      _measures = measures;
    });
  }

  void _showCupertinoPicker(BuildContext context, stockLists) {
    var names = stockLists;
    List<Widget> options = names.map<Widget>((e) {
      var e2 = "${e['code']} | ${e['name']}";
      return Text(e2);
    }).toList();
    final picker = CupertinoPicker(
        itemExtent: 40,
        backgroundColor: Colors.white,
        onSelectedItemChanged: (position) {
          setState(() {
            _stockName = names[position]['name'];
            _stockNumber = names[position]['code'];
            fetchData();
          });
        },
        children: options);
    showCupertinoModalPopup(
        context: context,
        builder: (cxt) {
          return Container(
            height: 200,
            child: picker,
          );
        });
  }
}

/// Sample linear data type.
class LinearSales {
  final DateTime date;
  final double r1;
  final double r2;

  dynamic getProp(String key) => <String, dynamic>{
        'r1': r1,
        'r2': r2,
      }[key];

  LinearSales(this.date, this.r1, this.r2);
}
