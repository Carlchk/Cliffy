import 'dart:async';
import 'dart:convert';

import 'package:cx256/model/geomodel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
//import 'package:cx256/model/UIdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_controller/map_controller.dart';
import 'package:provider/provider.dart';

import 'package:user_location/user_location.dart';
import 'package:validators/validators.dart';
import 'package:cx256/logic.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<GeoModel> _geoDatas = List<GeoModel>();
  List<GeoModel> _geoDatasForDisplay = List<GeoModel>();

  UserLocationOptions userLocationOptions;
  List<Marker> markers = [];
  FocusNode _contentFocusNode = new FocusNode();
  var _maptextbarcontroller = TextEditingController();
  bool showMainMenu = false;

  MapController mapController = MapController();
  StatefulMapController statefulMapController;
  StreamSubscription<StatefulMapControllerStateChange> sub;

  @override
  void dispose() {
    super.dispose();
  }

  var geolocator = Geolocator();
  //Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  Future<String> _loadDB() async {
    print('loading json db');
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
    mapController = MapController();
    statefulMapController = StatefulMapController(mapController: mapController);
    loadGeoDatas().then((value) {
      setState(() {
        _geoDatas.addAll(value);
        _geoDatasForDisplay = _geoDatas;
      });
    });
    super.initState();
  }

  void hideMenu() {
    setState(() {
      showMainMenu = false;
      _contentFocusNode.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    void _handleOnPositionChanged(
        MapPosition position, bool hasGesture, BuildContext context) {
      if (hasGesture == true) {
        print("hasGesture:true - $position");
        hideMenu();
      } else {
        print("hasGesture:false - $position");
      }
    }

    userLocationOptions = UserLocationOptions(
      context: context,
      mapController: mapController,
      markers: markers,
    );

    _customSearchBar() {
      return Positioned(
        top: 50.0,
        right: 15.0,
        left: 15.0,
        child: Container(
          height: 50.0,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1.0, 5.0),
                  blurRadius: 10,
                  spreadRadius: 3)
            ],
          ),
          child: TextField(
            cursorColor: Colors.black,
            focusNode: _contentFocusNode,
            controller: _maptextbarcontroller,
            onTap: () {
              setState(() {
                showMainMenu = true;
              });
            },
            onChanged: (text) {
              text = text.toLowerCase();
              print("Text Seaching: " + text);
              setState(() {
                _geoDatasForDisplay = _geoDatas.where((geoData) {
                  var geoDataContent = geoData.facilityName.toLowerCase();
                  print("Result: " + geoDataContent);
                  return geoDataContent.contains(text);
                }).toList();
              });
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              hintText: "Search...",
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
            ),
          ),
        ),
      );
    }

    return new Scaffold(
      body: ConstrainedBox(
        constraints: new BoxConstraints.expand(),
        child: new Stack(
          children: <Widget>[
            new FlutterMap(
              options: new MapOptions(
                //center: new LatLng(22.302711, 114.177216),
                onPositionChanged: (position, hasGesture) =>
                    _handleOnPositionChanged(position, hasGesture, context),
                plugins: [
                  UserLocationPlugin(),
                ],
                zoom: 16.0,
              ),
              layers: [
                MarkerLayerOptions(markers: statefulMapController.markers),
                TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(markers: markers),
                userLocationOptions,
              ],
              mapController: mapController,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _customSearchBar(),
                      Expanded(
                        child: Visibility(
                          visible: showMainMenu,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 250.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(1.0, 5.0),
                                      blurRadius: 10,
                                      spreadRadius: 3)
                                ],
                              ),
                              child: ListView.builder(
                                padding: EdgeInsets.all(10.0),
                                itemCount: _geoDatasForDisplay.length + 1,
                                itemBuilder: (context, index) {
                                  return index == 0
                                      ? Container()
                                      : _itemListingBuilder(index - 1);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void goAddPoint(LatLng geoPoint, String fid) {
    statefulMapController.centerOnPoint(geoPoint);
    statefulMapController.zoomTo(14.0);
    statefulMapController.addMarker(
        marker: Marker(
          point: geoPoint,
         builder: (ctx) =>
            new Icon(Icons.room),
        ),
        name: fid);
        debugPrint(geoPoint.toString());
  }

  _itemListingBuilder(index) {
    return Expanded(
      child: Card(
        child: InkWell(
          onTap: () {
            var geoPoint = LatLng(
                _geoDatasForDisplay[index].latitude.toDouble(),
                _geoDatasForDisplay[index].longitude.toDouble());
            goAddPoint(geoPoint, _geoDatasForDisplay[index].fid.toString());
            hideMenu();
            //print(_geoDatasForDisplay[index].longitude.toString() + "," + _geoDatasForDisplay[index].latitude.toString());
          },
          child: Padding(
            padding: const EdgeInsets.only(
                top: 7.0, bottom: 7.0, left: 8.0, right: 8.0),
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
        ),
      ),
    );
  }
}
