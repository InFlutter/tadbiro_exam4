import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String name;
  final DateTime date;
  final List<int> location;
  final String description;
  final List<String> bannerUrl;
  final bool isLiked;
  EventModel({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
    required this.bannerUrl,
    required this.isLiked
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    id: json['uid'] as String? ?? '',
    name: json['name'] as String? ?? '',
    date: (json['date'] != null
        ? (json['date'] as Timestamp).toDate()
        : DateTime.now()),
    location: (json['location'] as List<dynamic>).cast<int>() ?? [],
    description: json['description'] as String? ?? '',
    bannerUrl: (json['banner_url'] as List<dynamic>).cast<String>() ?? [],
    isLiked: json['is_like'] as bool? ?? false,
  );

  // copyWith metodi bizaga bloc emit qilganimzda classni holatini yani qiymatini o'zgartirish uchun funksiya
  EventModel copyWith({
    String? uid,
    String? title,
    String? name,
    DateTime? date,
    List<int>? location,
    String? description,
    List<String>? bannerUrl,
    bool? isLiked,
  }) =>
      EventModel(
        id: uid ?? this.id,
        name: name ?? this.name,
        date: date ?? this.date,
        location: location ?? this.location,
        description: description ?? this.description,
        bannerUrl: bannerUrl ?? this.bannerUrl,
        isLiked: isLiked?? this.isLiked,
      );

  static EventModel initialValue() => EventModel(
    id: '',
    name: '',
    date: DateTime.now(),
    location: [],
    description: '',
    bannerUrl: [],
    isLiked: false,
  );

  Map<String, dynamic> toJson() =>{
    'name': name,
    'date': Timestamp.fromDate(date),
    'location': location,
    'description': description,
    'banner_url': bannerUrl,
    'uid': id,
    'is_like': isLiked,
  };
  Map<String, dynamic> toUpdateJson() =>{
    'name': name,
    'date': Timestamp.fromDate(date),
    'location': location,
    'description': description,
    'banner_url': bannerUrl,
    'is_like': isLiked,
  };
}