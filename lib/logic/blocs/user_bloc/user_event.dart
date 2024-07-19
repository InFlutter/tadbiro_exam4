import '../../../data/models/event.dart';
import '../../../data/models/user/user_model.dart';

abstract class UserEvent{}

class UserInsertEvent extends UserEvent{
  final UserModel insertUserData;
  UserInsertEvent(this.insertUserData);
}

class UserFetchedEvent extends UserEvent{}
class UserUpdateEvent extends UserEvent{
  final UserModel updateUserData;
  UserUpdateEvent(this.updateUserData);
}

class FetchUserEvent extends UserEvent{}
class InsertLikeEvent extends UserEvent{
  final EventModel eventModel;
  InsertLikeEvent(this.eventModel);
}
