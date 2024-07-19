
import '../../../data/models/user/user_model.dart';

abstract class UserState{}

class UserLoadingState extends UserState{}

class UserSuccessState extends UserState{
  final UserModel userData;
  UserSuccessState({required this.userData});
}

class UserErrorState extends UserState{
  final String errorMessage;
  UserErrorState({required this.errorMessage});
}

class UserInitialState extends UserState{}