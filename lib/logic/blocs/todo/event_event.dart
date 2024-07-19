import 'package:equatable/equatable.dart';
import '../../../data/models/event.dart'; // Adjust import as per your project structure

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => [];
}

class FetchEvent extends EventEvent {}

class AddEvent extends EventEvent {
  final EventModel event;

  AddEvent(this.event);

  @override
  List<Object?> get props => [event];
}

class EditEvent extends EventEvent {
  final EventModel event;

  EditEvent(this.event);

  @override
  List<Object?> get props => [ event];
}

class DeleteEvent extends EventEvent {
  final String id;

  DeleteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
