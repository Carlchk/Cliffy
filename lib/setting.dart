import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cx256/model/UIdata.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingState createState() => new _SettingState();
}

class _SettingState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(UIData.setting),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  UIData.appName,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 38.0,
                                  foreground: Paint()..shader = UIData.gradientText,

                        ),
                ),
                Divider(),
                Text('Designed and Engineered by '),
                Text(
                  UIData.author,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Divider(),
                Text('Version'),
                Text(
                  UIData.version,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Divider(),
                Text('Last Updated:'),
                Text(
                  UIData.lastupdate,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Divider(),
                Text('Build:'),
                Text(
                  UIData.na,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Divider(),
                new Center(
                  child: new InkWell(
                      child: new Text(
                        'GitHub',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      onTap: () => launch('https://github.com/Carlchk')),
                ),
                Divider(),
                Text('This prototype is built with Flutter. '),
                Divider(),
                FlutterLogo(size: 50)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
