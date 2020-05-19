import 'dart:convert';

import 'package:cx256/model/geomodel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
//import 'package:cx256/model/UIdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'package:user_location/user_location.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var geolocator = Geolocator();
  //Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
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

  Widget mainMenu() {
    return Scaffold(
        body: Container(
      height: 42.0,
      width: 42.0,
      color: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    MapController mapController = MapController();
    UserLocationOptions userLocationOptions;
    List<Marker> markers = [];
    FocusNode _contentFocusNode = new FocusNode();
    var _maptextbarcontroller = TextEditingController();
    bool showMainMenu = false;

    @override
    void dispose() {
      super.dispose();
    }

    void _handleOnPositionChanged(
        MapPosition position, bool hasGesture, BuildContext context) {
      if (hasGesture == true) {
        print("hasGesture:true - $position");
        _contentFocusNode.unfocus();
      } else {
        print("hasGesture:false - $position");
      }
    }

    @override
    void initState() {
      super.initState();
      _contentFocusNode.unfocus();
    }

    userLocationOptions = UserLocationOptions(
      context: context,
      mapController: mapController,
      markers: markers,
    );

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
                      Positioned(
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
                            readOnly: true,
                            onTap: (){
                              
                            },
                            cursorColor: Colors.black,
                            focusNode: _contentFocusNode,
                            controller: _maptextbarcontroller,
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
                      ),
                      !showMainMenu
                          ? SizedBox(
                              height: 1,
                              width: 1,
                            )
                          : SafeArea(
                              child: new SizedBox(
                                  height: 400,
                                  child: ListView.builder(
                                      itemCount: 100,
                                      itemBuilder:
                                          (BuildContext ctxt, int Index) {
                                        return new Text(Index.toString());
                                      })),
                            )
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
}
