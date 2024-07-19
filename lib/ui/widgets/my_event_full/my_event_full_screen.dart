import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tadbiroemas_78/ui/widgets/my_event_full/my_notification.dart';

import '../../../data/models/event.dart';

class EventScreen extends StatelessWidget {
  final EventModel event;
  const EventScreen({Key? key, required this.event}) : super(key: key);

  @override

  Widget build(BuildContext context) {
     bool _alwaysUse24HourFormat = true;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(event.bannerUrl[0].toString()),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 8),
                      Text(event.date.toString()),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 8),
                      Text(event.location.toString()),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.people),
                      SizedBox(width: 8),
                      Text('${event} kishi bormoqda\nSiz ham ro‘yxatdan o‘ting'),
                    ],
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(event.bannerUrl.toString()),
                    ),
                    title: Text("bilolbek@gmail.com"),
                    subtitle: Text('Tadbir tashkilotchisi'),
                  ),
                  SizedBox(height: 16),
                  Text("Event haqida malumot",style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),),
                  Text(
                    event.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 200,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(41.2995, 69.2401), // Coordinates for Toshkent
                        zoom: 12,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (ctx){
                          return BookingScreen();
                        },),);
                        // Handle register action
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(16),
                      ),
                      child: Text(
                        "Ro'yxatdan O'tish",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
