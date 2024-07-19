import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tadbiroemas_78/logic/blocs/todo/event_bloc.dart';
import 'package:tadbiroemas_78/logic/blocs/todo/event_event.dart';
import 'package:tadbiroemas_78/ui/screens/my_location/my_location_screen.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../data/models/event.dart';
import '../../data/models/user/user_model.dart';
import '../../logic/blocs/user_bloc/user_bloc.dart';
import '../../logic/blocs/user_bloc/user_event.dart';
import '../screens/home_screen.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  late YandexMapController controller;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final LatLng najotalim = LatLng(41, 21.3232);

  final _formKey = GlobalKey<FormState>();
  String _name = '';
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  String _location = '';
  String _description = '';
  List<String> _bannerUrls = [];
  File? _selectedImage;
  LatLng? pointToreturn;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final fileName = 'events/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance.ref().child(fileName);
      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _addEvent() async {
    if (_nameController.text.isEmpty || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    final imageUrl = await _uploadImage(_selectedImage!);

    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image')),
      );
      return;
    }

    // Save event information to Firestore
    final event = EventModel(
      id: '',
      name: _nameController.text,
      date: _date,
      location: [], // You might need to adjust this if location is used
      description: _description,
      bannerUrl: [imageUrl],
      isLiked: false
    );

    final responce = await FirebaseFirestore.instance
        .collection('events')
        .add(event.toJson());
    await FirebaseFirestore.instance
        .collection("events")
        .doc(responce.id)
        .update({"uid": responce.id});

    // Show a success message and clear fields
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event added successfully')),
    );

    _nameController.clear();

    setState(() {
      _selectedImage = null;
    });

    // Navigate to HomeScreen or EventPage
    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yangi tadbir yaratish')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Tadbir nomi'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tadbir nomini kiriting';
                    }
                    return null;
                  },
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Kuni',
                        suffixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                      controller: TextEditingController(
                        text: "${_date.toLocal()}".split(' ')[0],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectTime(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Vaqti',
                        suffixIcon: Icon(Icons.access_time_outlined),
                      ),
                      controller: TextEditingController(
                        text: _time.format(context),
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  onTap: () async {
                   pointToreturn = await Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return MapScreen(
                        locationToGo: najotalim,
                      );
                    }));
                   _locationController.text = pointToreturn.toString();
                  },
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'location';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Tadbir haqida ma\'lumot',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tadbir haqida ma\'lumot kiriting';
                    }
                    return null;
                  },
                  onSaved: (value) => _description = value!,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        _pickImage(ImageSource.camera);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.camera,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _pickImage(ImageSource.gallery);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.install_desktop,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ZoomTapAnimation(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _addEvent();
                      final event = EventModel(
                        id: '',
                        name: _nameController.text,
                        date: _date,
                        location: [], // You might need to adjust this if location is used
                        description: _description,
                        bannerUrl: [],
                        isLiked: false
                      );
                      UserModel userModel = context.read<UserBloc>().userData;
                      List<EventModel> events = userModel.yesEvent;
                      events.add(event);
                      userModel = userModel.copyWith(
                        yesEvent: events,
                      );
                      context.read<UserBloc>().add(UserUpdateEvent(userModel));
                      context.read<EventBloc>().add(FetchEvent());
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.deepPurple,
                    ),
                    child: const Center(
                      child: Text(
                        'Yaratish',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
