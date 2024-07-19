import '../event.dart';

class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String imageUrl;
  final String userUid;
  final List<EventModel> yesEvent;
  final List<EventModel> isLike;
  final List<EventModel> noEvent;
  final List<EventModel> yEvent;

  UserModel({
    required this.userUid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.imageUrl,
    required this.yesEvent,
    required this.isLike,
    required this.noEvent,
    required this.yEvent,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userUid: json['userUid'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      yesEvent: (json['yesEvent'] as List?)
              ?.map((e) => EventModel.fromJson(e))
              .toList() ??
          [],
      isLike: (json['isLike'] as List?)
              ?.map((e) => EventModel.fromJson(e))
              .toList() ??
          [],
      noEvent: (json['noEvent'] as List?)
              ?.map((e) => EventModel.fromJson(e))
              .toList() ??
          [],
      yEvent: (json['yEvent'] as List?)
              ?.map((e) => EventModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'userUid': userUid,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'imageUrl': imageUrl,
        'yesEvent': yesEvent.map((e) => e.toJson()).toList(),
        'isLike': isLike.map((e) => e.toJson()).toList(),
        'noEvent': yesEvent.map((e) => e.toJson()).toList(),
        'yEvent': isLike.map((e) => e.toJson()).toList(),
      };

  Map<String, dynamic> toUpdateJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'imageUrl': imageUrl,
        'yesEvent': yesEvent.map((e) => e.toJson()).toList(),
        'isLike': isLike.map((e) => e.toJson()).toList(),
        'noEvent': yesEvent.map((e) => e.toJson()).toList(),
        'yEvent': isLike.map((e) => e.toJson()).toList(),
      };

  UserModel copyWith({
    String? userUid,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? imageUrl,
    List<EventModel>? yesEvent,
    List<EventModel>? isLike,
    List<EventModel>? noEvent,
    List<EventModel>? yEvent,
  }) {
    return UserModel(
      userUid: userUid ?? this.userUid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      imageUrl: imageUrl ?? this.imageUrl,
      yesEvent: yesEvent ?? this.yesEvent,
      isLike: isLike ?? this.isLike,
      noEvent: noEvent ?? this.noEvent,
      yEvent: yEvent ?? this.yEvent,
    );
  }

  static UserModel initialValue() => UserModel(
        userUid: '',
        firstName: '',
        lastName: '',
        email: '',
        password: '',
        imageUrl: '',
        yesEvent: [],
        isLike: [],
        noEvent: [],
        yEvent: [],
      );
}
