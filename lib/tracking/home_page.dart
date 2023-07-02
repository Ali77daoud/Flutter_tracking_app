import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/tracking/location_service.dart';
import 'package:tracking_app/tracking/user_location.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LocationService locationService = LocationService();

  late GoogleMapController gmc;

  LatLng markerLat = const LatLng(0, 0);

  bool markerVis = false;

  @override
  void dispose() {
    super.dispose();
    locationService.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking'),
      ),
      body: StreamBuilder<UserLocation>(
          stream: locationService.locationStream,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: GoogleMap(
                          markers: {
                            Marker(
                                visible: true,
                                onTap: (() {
                                  print('marker');
                                }),
                                draggable: true,
                                onDragEnd: (LatLng lat) {
                                  print(lat);
                                },
                                markerId: const MarkerId('1'),
                                position: markerLat,
                                infoWindow: InfoWindow(
                                    title: '2',
                                    onTap: () {
                                      print('2 ////////////////////////');
                                    }))
                          },
                          onTap: (LatLng lat) {
                            setState(() {
                              markerLat = lat;
                              print(lat);
                            });
                          },
                          mapType: MapType.hybrid,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(snapshot.data!.latitude!,
                                snapshot.data!.longitude!),
                            zoom: 14.5,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            gmc = controller;
                            setState(() {
                              markerLat = LatLng(snapshot.data!.latitude!,
                                  snapshot.data!.longitude!);
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // move button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () async {
                              setState(() {
                                markerLat = LatLng(35.98888, 35.954545);
                              });

                              await gmc.animateCamera(CameraUpdate.newLatLng(
                                  LatLng(35.98888, 35.954545)));
                            },
                            ///////////
                            child: Container(
                              width: 80,
                              height: 40,
                              color: Colors.blue,
                              child: const Center(
                                  child: Text(
                                'New Position',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          ),
                          //////////////////////
                          ///my location
                          InkWell(
                            onTap: () async {
                              setState(() {
                                markerLat = LatLng(snapshot.data!.latitude!,
                                    snapshot.data!.longitude!);
                              });

                              await gmc.animateCamera(CameraUpdate.newLatLng(
                                  LatLng(snapshot.data!.latitude!,
                                      snapshot.data!.longitude!)));
                            },
                            ///////////
                            child: Container(
                              width: 80,
                              height: 40,
                              color: Colors.red,
                              child: const Center(
                                  child: Text(
                                'My Location',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              )),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                : const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
