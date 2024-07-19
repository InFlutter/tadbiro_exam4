import 'package:equatable/equatable.dart';
import '../../../data/models/event.dart'; // Adjust import as per your project structure

abstract class EventState   {
}
class EventLoadSuccess extends EventState {
  final List<EventModel> events;
  EventLoadSuccess(this.events);
}

class EventLoadInProgress extends EventState{}



class EventLoadFailure extends EventState {}
