import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_calculator/view_models/map/map_viewmodel.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late MapViewModel mapViewModel;

  @override
  void initState() {
    mapViewModel = GetIt.instance<MapViewModel>();
    mapViewModel.requestPermission().then((value) {
      mapViewModel.setCurrentPosition();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    mapViewModel.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Map"),
      ),
      body: StreamBuilder<CameraPosition>(
        stream: mapViewModel.kGooglePlexBehavior,
        builder: (context, snapshotKGooglePlex) {
          if(snapshotKGooglePlex.hasData == false){
            return const Center(child: CircularProgressIndicator());
          }
          CameraPosition getStateCameraPosition = snapshotKGooglePlex.data!;
          return StreamBuilder<Set<Marker>>(
            stream: mapViewModel.markersBehavior,
            builder: (context, snapshotMarkersBehavior) {
              Set<Marker>? getState = snapshotMarkersBehavior.data;
              return GoogleMap(
                zoomControlsEnabled: true,
                compassEnabled: true,
                mapType: MapType.normal,
                initialCameraPosition: getStateCameraPosition,
                myLocationEnabled: true,
                markers: getState ?? {},
                onMapCreated: (controller){
                  mapViewModel.googleMapController.complete(controller);
                },
                onTap: (latLng){
                  mapViewModel.addMarker(latLng);
                },
              );
            }
          );
        }
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding:  EdgeInsets.only(
            left: 30
          ),
          child: FloatingActionButton.extended(
            // onPressed: _goToTheLake,
            onPressed: (){
              mapViewModel.clearMarker();
              setState(() {

              });
            },
            label: const Text('Clear'),
            icon: const Icon(Icons.clear),
          ),
        )
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   // onPressed: _goToTheLake,
      //   onPressed: (){
      //     mapViewModel.setCurrentPosition();
      //     setState(() {
      //
      //     });
      //   },
      //   label: const Text('To the lake!'),
      //   icon: const Icon(Icons.directions_boat),
      // ),
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
