import 'package:cx256/Map.dart';
import 'package:cx256/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cx256/model/UIdata.dart';
import 'GeoListPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/First': (context) => GeoListPage(),
        "/Second": (context) => MapScreen(),
        "/Third":(context) => SettingPage()
      },
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.blue,
        //textTheme: TextTheme(bodyText2: TextStyle(color: Colors.black)),
      ),

      debugShowCheckedModeBanner: false,
      title: UIData.appName,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    //GeoListPage(),
    MapScreen(),
    SettingPage(),
  ];

 @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.lightBlue[800],
        items: const <BottomNavigationBarItem>[
          //BottomNavigationBarItem(
          //  icon: Icon(Icons.list),
           // title: Text(UIData.firstitem),
          //),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            title: Text(UIData.seconditem),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            title: Text(UIData.setting),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
