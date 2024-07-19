import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/event.dart'; // Adjust import as per your project structure

class FirebaseEventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<EventModel>> getEvents() {
    return _firestore.collection('events').snapshots().map(
          (snapshot) {
        return snapshot.docs
            .map((doc) => EventModel.fromJson(doc.data()))
            .toList();
      },
    );
  }

  Future<void> addEvent(EventModel event) async {
    print(event.toJson());
    await _firestore.collection('events').add(event.toJson());
  }

  Future<void> editEvent(String id, EventModel event) async {
    await _firestore.collection('events').doc(id).update(event.toJson());
  }

  Future<void> deleteEvent(String id) async {
    await _firestore.collection('events').doc(id).delete();
    print(id);
    print("________________________________________________________________");
  }
}
