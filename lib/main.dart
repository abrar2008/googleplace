import 'dart:async';
import 'dart:convert';

import 'package:apitcheck/ControllerMap.dart';
import 'package:apitcheck/model.dart';
import 'package:apitcheck/place/placeItem.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   Welcome? cate;
   bool status=false;
   ControllerMap Mapcontroller = Get.put(ControllerMap());
   bool? _serviceEnabled;
   PermissionStatus? _permissionGranted;
   var _addressFrom, _addressTo;

   static final CameraPosition _kGooglePlex = CameraPosition(
     target: LatLng(37.42796133580664, -122.085749655962),
     zoom: 14.4746,
   );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getdata();
    getpermission();

  }
  getpermission() async {
    _serviceEnabled = await Mapcontroller.location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await Mapcontroller.location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }
    _permissionGranted = await Mapcontroller.location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await Mapcontroller.location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    Mapcontroller.locationData = await Mapcontroller.location.getLocation();
    Mapcontroller.getlocation();
  }


 /* getdata() async {
    cate =await fetchAlbum();
    setState(() {
      status=true;
    });
    print("data");
  }*/
 /*  Future<Welcome> fetchAlbum() async {
     final response = await http
         .get(Uri.parse('https://newsapi.org/v2/everything?q=Apple&from=2021-10-29&sortBy=popularity&apiKey=16af523248764c1785a268352c10d726'));

     if (response.statusCode == 200) {
       // If the server did return a 200 OK response,
       // then parse the JSON.
       return Welcome.fromJson(jsonDecode(response.body));
     } else {
       // If the server did not return a 200 OK response,
       // then throw an exception.
       throw Exception('Failed to load album');
     }
   }
  Future<Welcome> getHttp() async {
   var response = await Dio().get('https://newsapi.org/v2/everything?q=Apple&from=2021-10-29&sortBy=popularity&apiKey=16af523248764c1785a268352c10d726');
    if (response.statusCode == 200) {
      return Welcome.fromJson(response.data);
    } else {
      print("Failed to load");
      throw Exception("Failed  to Load Post");
    }
  }*/

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:GetBuilder<ControllerMap>(
        builder: (value)=>Stack(
          children: [
            GoogleMap(
              markers: Set<Marker>.of(value.markers.values),
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                //_controller.complete(controller);
                value.controller=controller;
              },
            ),
            SingleChildScrollView(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.0,
                  child: Column(
                    children: <Widget>[
                      Card(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.0,
                          // margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          color:Colors.white,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(
                                flex: 1,
                                child: new Column(
                                  children: <Widget>[
                                    new Icon(
                                      Icons.my_location,
                                      size: 20.0,
                                      color: Colors.blue,
                                    ),
                                    new Icon(
                                      Icons.more_vert,
                                      size: 20.0,
                                      color: Colors.grey,
                                    ),
                                    new Icon(
                                      Icons.location_on,
                                      size: 20.0,
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                              ),
                              new Expanded(
                                flex: 5,
                                child:
                                
                                 Form(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        // one textfeild
                                        new Container(
                                          height: 50.0,
                                          width: MediaQuery.of(context).size.width -
                                              50,
                                          color: Colors.white,
                                          child: new Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[

                                             // one
                                              TextField(
                                                style: TextStyle(fontSize: 15),
                                                decoration:
                                                InputDecoration.collapsed(
                                                  fillColor:Colors.white,
                                                  hintStyle: TextStyle(
                                                      color: Colors.black),
                                                  hintText: "Enter the PickUp Location".tr,
                                                ),
                                                autofocus: false,
                                                focusNode: Mapcontroller.nodeFrom,
                                                controller: _addressFrom,
                                                onChanged: (String value) {
                                                  Mapcontroller.placeBloc.searchPlace(value);
                                                },
                                                onTap: () {
                                                  setState(() {
                                                    Mapcontroller.inputFrom = true;
                                                    Mapcontroller.inputTo = false;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),


                                        // seond textfeild
                                        Container(
                                          width: MediaQuery.of(context).size.width -
                                              50.0,
                                          height: 1.0,
                                          color: Colors.grey.withOpacity(0.4),
                                        ),
                                        new Container(
                                          height: 50.0,
                                          // width: MediaQuery.of(context).size.width,
                                          color: Colors.white,
                                          child: new Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              TextField(
                                                style:TextStyle(fontSize: 15),
                                                decoration:
                                                InputDecoration.collapsed(
                                                  fillColor: Colors.white,
                                                  hintStyle: TextStyle(
                                                      color: Colors.black),
                                                  hintText: "Enter the Dropoff Location".tr,
                                                ),
                                                focusNode: Mapcontroller.nodeTo,
                                                autofocus: false,
                                                controller: _addressTo,
                                                onChanged: (String value) {
                                                  Mapcontroller.placeBloc.searchPlace(value);
                                                },
                                                onTap: () {
                                                  setState(() {
                                                    Mapcontroller.inputTo = true;
                                                    Mapcontroller.inputFrom = false;
                                                    print(Mapcontroller.inputTo);
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Mapcontroller.inputTo != true
                          ? Container(
                        color: Colors.white,
                        child: StreamBuilder(
                            stream: Mapcontroller.placeBloc.placeStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data == "start") {
                                  return Center(
                                    child: CupertinoActivityIndicator(),
                                  );
                                }
                               Mapcontroller.places = snapshot.data as List<PlaceItemRes>?;
                                return ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: Mapcontroller.places!.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(Mapcontroller.places!
                                          .elementAt(index)
                                          .name
                                          .runtimeType ==
                                          String
                                          ? Mapcontroller.places!.elementAt(index).name
                                          : ""),
                                      subtitle: Text(Mapcontroller.places!
                                          .elementAt(index)
                                          .address
                                          .runtimeType ==
                                          String
                                          ? Mapcontroller.places!
                                          .elementAt(index)
                                          .address
                                          : ""),
                                      onTap: () {
                                        Mapcontroller.FromData(index,context);
                                      },
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      Divider(
                                        height: 1,
                                        color: Color(0xfff5f5f5),
                                      ),
                                );
                              } else {
                                return Container();
                              }
                            }),
                      )
                          : Container(
                        color: Colors.white,
                        child: StreamBuilder(
                            stream: value.placeBloc.placeStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data == "start") {
                                  return Center(
                                    child: CupertinoActivityIndicator(),
                                  );
                                }
                               Mapcontroller.places2 = snapshot.data as List<PlaceItemRes>?;
                                return ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: Mapcontroller.places2!.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(Mapcontroller.places2!
                                          .elementAt(index)
                                          .name
                                          .runtimeType ==
                                          String
                                          ? Mapcontroller.places2!.elementAt(index).name
                                          : ""),
                                      subtitle: Text(Mapcontroller.places2!
                                          .elementAt(index)
                                          .address
                                          .runtimeType ==
                                          String
                                          ? Mapcontroller.places2!
                                          .elementAt(index)
                                          .address
                                          : ""),
                                      onTap: () {
                                        Mapcontroller.ToData(context,index);
                                      },
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      Divider(
                                        height: 1,
                                        color: Color(0xfff5f5f5),
                                      ),
                                );
                              } else {
                                return Container();
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),


     /* body: Center(
        child:status==false?CircularProgressIndicator():ListView.builder(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: cate!.articles!.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      //Navigator.pushNamed(context,ProductCategories.routeName );
                    },
                    child: Container(
                      height: 200,
                      width: 400,
                      padding: EdgeInsets.all(10),
                       decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),),
                      child: Image.network(cate!.articles![index].urlToImage.toString(),fit: BoxFit.contain,width: 10,height: 10,),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    cate!.articles![index].author.toString(),
                    style: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        ),
      ),*/
    );
  }

}
