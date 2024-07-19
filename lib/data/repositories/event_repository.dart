
import '../../services/firebase_event_service.dart';
import '../models/event.dart';

class EventRepository {
  final FirebaseEventService _firebaseEventService;

  EventRepository({required FirebaseEventService firebaseEventService})
      : _firebaseEventService = firebaseEventService;

  Stream<List<EventModel>> getEvents() {
    return _firebaseEventService.getEvents();
  }

  Future<void> addEvent(EventModel event) async {
    await _firebaseEventService.addEvent(event);
  }

  Future<void> editEvent(String id, EventModel event) async {
    await _firebaseEventService.editEvent(id, event);
  }

  Future<void> deleteEvent(String id) async {
    await _firebaseEventService.deleteEvent(id);
  }
}
