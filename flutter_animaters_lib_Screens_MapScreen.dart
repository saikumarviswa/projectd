import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

void main() => runApp(MapScreen());

class MapScreen extends StatefulWidget{

  MapScreen ({Key key}) : super(key: key);

  @override
  MapScree createState() => new MapScree();
}

class MapScree extends State<MapScreen> {
  List<Marker> allMarkers = [];

  GoogleMapController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allMarkers.add(Marker(
        markerId: MarkerId('myMarker'),
        draggable: true,
        onTap: () {
          print('Marker Tapped');
        },
        position: LatLng(16.517454,81.725342)));

  }

  static final CameraPosition _kGooglePlex =
  CameraPosition(
    target: LatLng(17.4435, 78.3772),
    zoom: 14.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps'),
        backgroundColor: Colors.redAccent,
      ),
      body: Stack(
          children: [Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              initialCameraPosition: _kGooglePlex,
              markers: Set.from(markers.values),
              onMapCreated: mapCreated,
              mapType: MapType.satellite,
            ),
          ),
            /*Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: movetoBoston,
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.green
                  ),
                  child: Icon(Icons.forward, color: Colors.white),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: movetoNewYork,
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.red
                  ),
                  child: Icon(Icons.backspace, color: Colors.white),
                ),
              ),
            )*/
          ]
      ),
    );
  }

  Map markers={};
  List listMarkerIds=List();
  final GlobalKey scaffoldKey = GlobalKey();
  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });


    MarkerId markerId1 = MarkerId("1");
    MarkerId markerId2 = MarkerId("2");
    MarkerId markerId3 = MarkerId("3");

    listMarkerIds.add(markerId1);
    listMarkerIds.add(markerId2);
    listMarkerIds.add(markerId3);


    Marker marker1=Marker(markerId: markerId1,
        position: LatLng(17.4435, 78.3772),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueCyan),
        infoWindow: InfoWindow(
            title: "Hytech City",onTap: (){
          Scaffold.of(context).
          showBottomSheet((context) => Container(
            child:
            getBottomSheet("17.4435, 78.3772"),
            height: 250,
            color: Colors.transparent,
          ));

        },snippet: "Snipet Hitech City"
        ));

    Marker marker2=Marker(markerId: markerId2,
      position: LatLng(17.4837, 78.3158),
      icon:
      BitmapDescriptor.defaultMarkerWithHue
        (BitmapDescriptor.hueGreen),);
    Marker marker3=
    Marker(markerId:
    markerId3,position:
    LatLng(17.5169, 78.3428),
        infoWindow: InfoWindow(
            title: "Miyapur",onTap: (){},snippet: "Miyapur"
        ));

    setState(() {
      markers[markerId1]=marker1;
      markers[markerId2]=marker2;
      markers[markerId3]=marker3;
    });
  }

  movetoBoston() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(16.517474,81.725362), zoom: 14.0, bearing: 45.0, tilt: 45.0),
    ));
  }

  movetoNewYork() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(16.517454,81.725342), zoom: 12.0),
    ));
  }


  Widget getBottomSheet(String s) {
    return Stack(
      children: [
        Container(

          margin: EdgeInsets.only(top: 32),
          color: Colors.white,
          child: Column(
            children: [
              Container(
                color: Colors.blueAccent,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hytech City Public School \n CBSC", style: TextStyle(
                          color: Colors.white,
                          fontSize: 14
                      ),),
                      SizedBox(height: 5,),
                      Row(children: [

                        Text("4.5", style: TextStyle(
                            color: Colors.white,
                            fontSize: 12
                        )),
                        Icon(Icons.star, color: Colors.yellow,),
                        SizedBox(width: 20,),
                        Text("970 Folowers", style: TextStyle(
                            color: Colors.white,
                            fontSize: 14
                        ))
                      ],),
                      SizedBox(height: 5,),
                      Text("Memorial Park", style: TextStyle(
                          color: Colors.white,
                          fontSize: 14
                      )),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                children: [SizedBox(width: 20,),
                  Icon(Icons.map, color: Colors.blue,),
                  SizedBox(width: 20,), Text("$s")],
              ),
              SizedBox(height: 20,),
              Row(
                children: [SizedBox(width: 20,),
                  Icon(Icons.call, color: Colors.blue,),
                  SizedBox(width: 20,),
                  Text("040-123456")],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topRight,

            child: FloatingActionButton(
                child: Icon(Icons.navigation),
                onPressed: () {

                }),
          ),
        )
      ],

    );
  }
}


