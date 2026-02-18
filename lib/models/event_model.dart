import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String organizerId;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.organizerId,
  });

  factory EventModel.fromFirestore(Map<String, dynamic> data, String id) {
    return EventModel(
      id: id,
      title: data['title'],
      description: data['description'],
      date: data['date'].toDate(),
      location: data['location'],
      organizerId: data['organizerId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'location': location,
      'organizerId': organizerId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
