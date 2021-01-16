import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

abstract class WebViewNavBarDelegate {
  WebViewController controller;
}

class WebViewNavBar extends StatelessWidget {
  WebViewNavBarDelegate delegateWidget;
  WebViewNavBar({this.delegateWidget});

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
              delegateWidget?.controller?.goBack();
              break;
            case 1:
              delegateWidget?.controller?.goForward();
              break;
            case 2:
              Navigator.pop(context);
              break;
            default:
          }
        });
  }
}
