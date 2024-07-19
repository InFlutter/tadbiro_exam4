import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tadbiroemas_78/ui/screens/home_screen.dart';
class MyHomePage extends StatelessWidget {

  const MyHomePage({
    required this.alwaysUse24HourFormat,
    required this.onAlwaysUse24HourFormatChanged});

  final bool alwaysUse24HourFormat;
  final ValueChanged<bool> onAlwaysUse24HourFormatChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Switch(
                value: alwaysUse24HourFormat,
                onChanged: onAlwaysUse24HourFormatChanged,
              ),
              FilledButton(
                onPressed: () {
                  // There is NO WAY to make this show the 12-hour UI with AM/PM:
                  showTimePicker(context: context, initialTime: TimeOfDay.now());
                },
                child: const Text("Show time picker"),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (ctx){
                    return HomeScreen();
                  },),);
                },
                child: const Text("Eslatmani Qoshish"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class BookingScreen extends StatefulWidget {

  const BookingScreen({super.key,});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int hisob = 0;
  String paymentMethod = 'Click';

  void _incrementSeats() {
    setState(() {
      if(hisob < 5) {
        hisob++;
      }    });
  }

  void _decrementSeats() {
    setState(() {
      if (hisob > 0) hisob--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Tafsilotlar", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ro\'yxatdan O\'tish',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Joylar sonini tanlang', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: _decrementSeats, icon: Icon(Icons.remove)),
                Text('$hisob', style: TextStyle(fontSize: 24)),
                IconButton(onPressed: _incrementSeats, icon: Icon(Icons.add)),
              ],
            ),
            SizedBox(height: 16),
            Text('To\'lov turini tanlang', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            ListTile(
              title: Text('Click'),
              leading: Radio(
                value: 'Click',
                groupValue: paymentMethod,
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value.toString();
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Payme'),
              leading: Radio(
                value: 'Payme',
                groupValue: paymentMethod,
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value.toString();
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Naqd'),
              leading: Radio(
                value: 'Naqd',
                groupValue: paymentMethod,
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value.toString();
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(alwaysUse24HourFormat: false, onAlwaysUse24HourFormatChanged: (value){
                          })));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text('Keyingi', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}