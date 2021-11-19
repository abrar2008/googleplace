import 'package:apitcheck/place/placeItem.dart';
import 'package:apitcheck/place/place_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ControllerMap extends GetxController{

  GoogleMapController? controller;
  Location location = new Location();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? locationData;

  FocusNode nodeFrom = FocusNode();
  FocusNode nodeTo = FocusNode();
  bool checkAutoFocus = false, inputFrom = false, inputTo = false;
  List<Map<String, dynamic>> dataFrom = [];
  List<Map<String, dynamic>> dataTo = [];
  var _addressFrom, _addressTo;
  var placeBloc = PlaceBloc();
  String? valueFrom, valueTo;
  List<PlaceItemRes>? places;
  List<PlaceItemRes>? places2;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  // one textfeild
  FromData(index,context){
    dataFrom.clear();
    Map<String, dynamic> value = {
      "name": places!
          .elementAt(index)
          .name,
      "address": places!
          .elementAt(index)
          .address,
      "lat":
      places!.elementAt(index).lat,
      "long":
      places!.elementAt(index).lng
    };
    print('dataFrom: ' + value.toString());
    places!.clear();
    FocusScope.of(context).requestFocus(nodeTo);
    dataFrom.add(value);
    valueFrom = places!.elementAt(index).name.toString();
    _addressFrom = TextEditingController(text:valueFrom);
    inputTo = true;
    update();
    //new address from

    print(dataFrom);

  }
  
  // two textfeild
  ToData(context,index){
    dataTo.clear();
    Map<String, dynamic> value = {
      "name": places2!
          .elementAt(index)
          .name,
      "address": places2!
          .elementAt(index)
          .address,
      "lat":
      places2!.elementAt(index).lat,
      "long":
      places2!.elementAt(index).lng
    };
    print('dataTo: ' + value.toString());
      valueTo = places2!
          .elementAt(index)
          .name
          .toString();
      _addressTo =
          TextEditingController(
              text: places2!
                  .elementAt(index)
                  .name
                  .toString());
      FocusScope.of(context)
          .requestFocus(
          new FocusNode());
      dataTo.add(value);
      print(dataTo);
    places2!.clear();
      update();
      //directions
      // DrawRoute();

  }
  
  
  getlocation(){
    location.onLocationChanged.listen((LocationData currentLocation) {
      print(currentLocation.toString());
      controller!.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(currentLocation.latitude!.toDouble(), currentLocation.longitude!.toDouble()),
              tilt: 0,
              zoom: 18.00)));
      updateMarkerAndCircle(currentLocation);
      // Use current location
    });
  }
  
  void updateMarkerAndCircle(LocationData newLocalData) {

    final MarkerId markerIdFrom = MarkerId("My Location");
    final Marker marker = Marker(
        markerId: markerIdFrom,
        //position: LatLng(_fromLocation.latitude, _fromLocation.longitude),
        position: LatLng(newLocalData.latitude!.toDouble(), newLocalData.longitude!.toDouble()),
        infoWindow: InfoWindow(title: "Current"),
        icon:
        // ? BitmapDescriptor.fromAsset("assets/currentmarker.png")
        // : BitmapDescriptor.fromAsset("assets/currentmarker.png"),
        BitmapDescriptor.defaultMarker

    );
      markers[markerIdFrom] = marker;
      update();

    print(markers.toString());

  }

}