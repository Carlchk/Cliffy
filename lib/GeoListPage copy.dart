import 'package:cx256/Map.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:cx256/model/geomodel.dart';
import 'package:flutter/services.dart';
import 'package:validators/validators.dart';
import 'package:cx256/model/UIdata.dart';

class GeoListPage extends StatefulWidget {
  @override
  _GeoListPageState createState() => _GeoListPageState();
}

class _GeoListPageState extends State<GeoListPage> {
  
  List<GeoModel> _geoDatas = List<GeoModel>();
  List<GeoModel> _geoDatasForDisplay = List<GeoModel>();

  ScrollController _scrollController;
  TextEditingController _textEditingController;
  FocusNode _contentFocusNode = FocusNode();
  bool showToTopBtn = false;

  Future<String> _loadDB() async {
    return await rootBundle.loadString('assets/db.json');
  }

  Future<List<GeoModel>> loadGeoDatas() async {
    var geoDatas = List<GeoModel>();
    String jsonString = await _loadDB();
    final geoDatasJson = json.decode(jsonString);
    for (var geoDataJson in geoDatasJson) {
      geoDatas.add(GeoModel.fromJson(geoDataJson));
    }
    return geoDatas;
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    loadGeoDatas().then((value) {
      setState(() {
        _geoDatas.addAll(value);
        _geoDatasForDisplay = _geoDatas;
      });
    });
    _contentFocusNode.unfocus();
    _fabuttonlistener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(UIData.appName),
        centerTitle: true,
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemBuilder: (context, index) {
          return index == 0
              ? _customSearchBar()
              : _itemListingBuilder(index - 1);
        },
        itemCount: _geoDatasForDisplay.length + 1,
      ),
      floatingActionButton: !showToTopBtn
          ? null
          : FloatingActionButton(
              child: Icon(Icons.arrow_upward),
              onPressed: () {
                _scrollController.animateTo(.0,
                    duration: Duration(milliseconds: 150), curve: Curves.ease);
              }),
    );
  }

_fabuttonlistener() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      //print(_scrollController.offset);
      _contentFocusNode.unfocus();
      if (_scrollController.offset < 100 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (_scrollController.offset >= 100 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
  }

  _customSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CupertinoTextField(
        placeholder: 'Search...',
        focusNode: _contentFocusNode,
        controller: _textEditingController,
        clearButtonMode: OverlayVisibilityMode.editing,
        onChanged: (text) {
          text = text.toLowerCase();
          if (isInt(text) == true && int.parse(text) < 65) {
            //print("Index Seaching: " + text);
            setState(() {
              //print(_geoDatasForDisplay.length);
              _geoDatasForDisplay = _geoDatas.where((geoData) {
                var geoDataIndex = geoData.fid.toString();
                return geoDataIndex.contains(text);
              }).toList();
            });
          } else {
            print("Text Seaching: " + text);
            setState(() {
              _geoDatasForDisplay = _geoDatas.where((geoData) {
                var geoDataContent = geoData.facilityName.toLowerCase();
                //print("Result: " + geoDataContent);
                return geoDataContent.contains(text);
              }).toList();
            });
          }
        },
      ),
    );
  }

  _itemListingBuilder(index) {
    
    return Card(
      child: InkWell(
        onTap: (){
          print(_geoDatasForDisplay[index].longitude.toString()+","+ _geoDatasForDisplay[index].latitude.toString());
        },
        child: Padding(
        padding: const EdgeInsets.only(
            top: 15.0, bottom: 15.0, left: 8.0, right: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_geoDatasForDisplay[index].facilityNameZh),
            Divider(),
            Text(
              _geoDatasForDisplay[index].facilityName,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    ),);
  }
}
