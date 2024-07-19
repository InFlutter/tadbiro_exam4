import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  final LatLng locationToGo;

  const MapScreen({Key? key, required this.locationToGo}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LocationData? myLocation;
  LatLng? myCurrentLocation;
  LatLng? selectedPoint;
  Marker? selectedPointMarker;
  Set<Polyline> polylines = {};
  TravelMode _currentTravelMode = TravelMode.driving;
  LatLng? pointToReturn;// Default travel mode

  @override
  void initState() {
    super.initState();
    _initLocationService();
  }

  Future<void> _initLocationService() async {
    await LocationService.init(); // Initialize location service

    // Fetch current location
    final currentLocation = await LocationService.fetchCurrentLocation();
    if (currentLocation != null) {
      setState(() {
        myCurrentLocation =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
      });
    }

    // Listen for live location updates
    LocationService.fetchLiveLocation().listen((location) {
      setState(() {
        myCurrentLocation = LatLng(location.latitude!, location.longitude!);
      });
    });

    // Fetch polylines initially
    if (myCurrentLocation != null) {
      _fetchPolylines(myCurrentLocation!, widget.locationToGo);
    }
  }

  Future<void> _fetchPolylines(LatLng from, LatLng to) async {
    final polylinesResult =
    await LocationService.getPolylines(from, to, _currentTravelMode);
    setState(() {
      if (polylinesResult.isNotEmpty) {
        // Clear previous polylines
        polylines.clear();

        // Add new polyline to the set
        polylines.add(
          Polyline(
            polylineId: PolylineId("route"),
            color: Colors.blue,
            width: 5,
            points: polylinesResult,
          ),
        );
      } else {
        // Handle case when no polylines are returned
        print("No polylines found!");
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    // Update marker position when camera moves
    selectedPointMarker = Marker(
      markerId: MarkerId(selectedPoint.toString()),
      position: position.target,

      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    pointToReturn = position.target;

    setState(() {
      selectedPoint = position.target;
    });
  }

  void addMarker() async {
    if (myCurrentLocation != null && selectedPoint != null) {
      final points = await LocationService.getPolylines(
        myCurrentLocation!,
        selectedPoint!,
        _currentTravelMode,
      );

      setState(() {
        polylines.add(
          Polyline(
            polylineId: PolylineId("route"),
            color: Colors.blue,
            width: 5,
            points: points,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        children: [
          if (myCurrentLocation != null)
            GoogleMap(
              onMapCreated: _onMapCreated,
              onCameraMove: _onCameraMove, // Call _onCameraMove when camera moves
              initialCameraPosition: CameraPosition(
                target: myCurrentLocation!,
                zoom: 15,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: {
                if (myCurrentLocation != null)
                  Marker(
                    markerId: MarkerId("MyLocation"),
                    position: myCurrentLocation!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueAzure),
                    infoWindow: InfoWindow(
                      title: "My Location",
                    ),
                  ),
                if (selectedPointMarker != null) selectedPointMarker!,
              },
              polylines: polylines,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          addMarker;
          Navigator.pop(context,pointToReturn);},


        child: Icon(Icons.add),
      ),
    );
  }
}

class LocationService {
  static final _location = Location();

  static bool _serviceEnabled = false;
  static PermissionStatus _permissionStatus = PermissionStatus.denied;
  static LocationData? currentLocation;

  static Future<void> init() async {
    await _checkService();
    if (_serviceEnabled) {
      await _checkPermission();
    }
  }

  // joylashuvni olish xizmatini yoniqmi tekshiramiz
  static Future<void> _checkService() async {
    _serviceEnabled = await _location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        // foydalanuvchi endi buni sozlamalardan to'g'irlash kerak
        return;
      }
    }
  }

  // joylashuvni olish uchun ruxsat so'raymiz
  static Future<void> _checkPermission() async {
    _permissionStatus = await _location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await _location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) {
        // foydalanuvchi endi buni sozlamalardan to'g'irlash kerak
        return;
      }
    }
  }

  static Future<LocationData?> fetchCurrentLocation() async {
    if (_serviceEnabled && _permissionStatus == PermissionStatus.granted) {
      currentLocation = await _location.getLocation();
      return currentLocation;
    }
    return null;
  }

  static Stream<LocationData> fetchLiveLocation() async* {
    yield* _location.onLocationChanged;
  }

  static Future<List<LatLng>> getPolylines(
      LatLng from,
      LatLng to,
      TravelMode travelMode,
      ) async {
    final polylinePoints = PolylinePoints();

    final result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: "AIzaSyA2_JDWv_mKN2BZXXVItytZOAHIJvmREMY",
      request: PolylineRequest(
        origin: PointLatLng(from.latitude, from.longitude),
        destination: PointLatLng(to.latitude, to.longitude),
        mode: travelMode,
      ),
    );

    if (result.points.isNotEmpty) {
      return result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    }

    print("No routes found!");

    return [];
  }
}

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class MyLocationScreen extends StatefulWidget {
//   const MyLocationScreen({super.key});
//
//   @override
//   State<MyLocationScreen> createState() => _MyLocationScreenState();
// }
//
// class _MyLocationScreenState extends State<MyLocationScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SizedBox(
//         width: 200,
//         height: 200,
//         child: GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: LatLng(38.8951, -77.0364),
//             zoom: 15,
//           ),
//         ),
//       ),
//     );
//   }
// }

