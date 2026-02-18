import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // creating event
  void addEvent(String title, String description, DateTime date) {
    firestore.collection('events').add({
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
    });
  }

  // remove expired events from timeline
  Stream<QuerySnapshot> getEvents() {
    return firestore
        .collection('events')
        .where('date', isGreaterThan: Timestamp.now())
        .snapshots();
  }

  //  expired events
  void deleteOldEvents() async {
    var oldEvents = await firestore
        .collection('events')
        .where('date', isLessThan: Timestamp.now())
        .get();

    for (var doc in oldEvents.docs) {
      doc.reference.delete();
    }
  }
}
