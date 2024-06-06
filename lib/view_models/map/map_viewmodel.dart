
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_calculator/core/dispose.dart';

class MapViewModel extends Dispose {

  final Completer<GoogleMapController> _googleMapController = Completer();
  final BehaviorSubject<Set<Marker>> _markersBehavior = BehaviorSubject<Set<Marker>>.seeded(<Marker>{});
  final BehaviorSubject<CameraPosition> _kGooglePlexBehavior = BehaviorSubject<CameraPosition>();

  Completer<GoogleMapController> get googleMapController => _googleMapController;
  BehaviorSubject<CameraPosition> get kGooglePlexBehavior => _kGooglePlexBehavior;
  BehaviorSubject<Set<Marker>> get markersBehavior => _markersBehavior;

  @override
  void dispose() {
    _markersBehavior.close();
  }

  Future<void> requestPermission() async {
    try{
      LocationPermission permission = await Geolocator.requestPermission();
      print('----:${permission}');
    }catch(error){
      print('---- error :${error}');
    }
  }

  void addMarker(LatLng latLng) async {
    Set<Marker> state = Set.from(_markersBehavior.value);
    int genMarkerId = state.length + 1;

    String imgurl = "https://www.fluttercampus.com/img/car.png";
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(imgurl))
        .load(imgurl))
        .buffer
        .asUint8List();

    Marker marker = Marker(
      markerId: MarkerId("TestMarker_$genMarkerId"),
      position: latLng,
      icon: BitmapDescriptor.fromBytes(bytes),
      infoWindow: InfoWindow(
        title: "TestMarker_$genMarkerId",
        snippet: "${latLng.latitude}, ${latLng.longitude}",
      ),
    );

    state.add(marker);
    _markersBehavior.sink.add(state);

  }

  void clearMarker(){
    _markersBehavior.value.clear();
  }

  Future<void> setCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;
    LatLng location = LatLng(lat, long);
    _kGooglePlexBehavior.sink.add(CameraPosition(
      target: location,
      zoom: 16.0,
    ));
  }
}