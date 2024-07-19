import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tadbiroemas_78/logic/blocs/user_bloc/user_event.dart';
import 'package:tadbiroemas_78/logic/blocs/user_bloc/user_state.dart';
import '../../../data/models/user/user_model.dart';

class UserBloc extends Bloc<UserEvent, UserState>{
  UserBloc() : super(UserInitialState()){
    on<UserInsertEvent>(_insertUser);
    on<UserUpdateEvent>(_addEvent);
    on<FetchUserEvent>(_fetchUserData);
  }
  UserModel userData = UserModel.initialValue();
  Future<void> _insertUser(UserInsertEvent event, Emitter<UserState> emit) async {
    try {
      emit(UserLoadingState());
      final String docId =  FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(docId).set(event.insertUserData.toJson());
      await FirebaseFirestore.instance.collection('users').doc(docId).update({
        "userUid": docId,
      });
      UserModel insertUserModel = event.insertUserData.copyWith(
        userUid: docId,
      );
      userData = insertUserModel;
      emit(UserSuccessState(userData: insertUserModel));
    }catch(error){
      throw Exception(error);
    }
  }

  Future<void> _addEvent(UserUpdateEvent event, Emitter<UserState> emit)async{
    try{
      emit(UserLoadingState());
      final String userDocId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(userDocId).update(event.updateUserData.toUpdateJson());
      userData = event.updateUserData;
      emit(UserSuccessState(userData: event.updateUserData));

    }catch(error){
      throw Exception(error);
    }
  }
  Future<void> _fetchUserData(FetchUserEvent event, Emitter<UserState> emit)async{
    try{
      emit(UserLoadingState());
      final String userDocId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(userDocId).get();
      userData = UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
      emit(UserSuccessState(userData: userData));
    }catch(error){
      throw Exception(error);
    }
  }

}