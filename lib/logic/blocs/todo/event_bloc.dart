import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tadbiroemas_78/data/repositories/event_repository.dart';
import 'package:tadbiroemas_78/logic/blocs/todo/event_event.dart';
import 'package:tadbiroemas_78/logic/blocs/todo/event_state.dart';
import '../../../data/models/event.dart';

class EventBloc extends Bloc<EventEvent, EventState>{
  final EventRepository _eventRepository;
  EventBloc({required EventRepository repository}) : _eventRepository = repository, super(EventLoadFailure()){
    on<FetchEvent>(_fetchEvents);
    on<DeleteEvent>(_deleteEvent);
    on<EditEvent>(_update);
  }
  List<EventModel> eventsData = [];

  Future<void> _fetchEvents(FetchEvent evnet, Emitter<EventState> emit)async{
    emit(EventLoadInProgress());
    try{
       QuerySnapshot querySnapshot =  await FirebaseFirestore.instance.collection('events').get();
       eventsData = querySnapshot.docs.map((doc) => EventModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
       emit(EventLoadSuccess(eventsData));
    }catch(error){
      throw Exception(error);
    }
  }
  Future<void> _deleteEvent(DeleteEvent event, Emitter<EventState> emit) async {
    emit(EventLoadInProgress());
    await _eventRepository.deleteEvent(event.id);
    QuerySnapshot querySnapshot =  await FirebaseFirestore.instance.collection('events').get();
    emit(EventLoadSuccess(querySnapshot.docs.map((doc) => EventModel.fromJson(doc.data() as Map<String, dynamic>)).toList()));
  }
  
  Future<void> _update(EditEvent event, Emitter<EventState> emit)async{
    try{
      emit(EventLoadInProgress());
      EventModel updateEvent = event.event;
      updateEvent = updateEvent.copyWith(
        isLiked: !event.event.isLiked,
      );
      await FirebaseFirestore.instance.collection('events').doc(event.event.id).update(updateEvent.toUpdateJson());
      add(FetchEvent());
    }catch(e){
      throw Exception(e);
    }
  }


}