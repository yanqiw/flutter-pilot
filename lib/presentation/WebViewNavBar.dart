
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
              icon: Icon(Icons.arrow_back), label: "后退"),
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_forward), label: "后退"),
          BottomNavigationBarItem(icon: Icon(Icons.close), label: "关闭")
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
