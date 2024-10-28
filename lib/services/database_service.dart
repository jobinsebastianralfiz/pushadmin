import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pushadmin/services/admin_notification_service.dart';
import 'package:pushadmin/services/authservice.dart';

import '../models/offer.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final AdminNotificationService _adminNotificationService =
      AdminNotificationService();

  //get active offers

  Stream<List<Offer>> getActiveOffers() {
    return _firestore
        .collection('offers')
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Offer.fromJosn(doc.data(), documentId: doc.id))
            .toList());
  }

  //save offer

  Future<Offer> saveOffer(Offer offer) async {
    if (!_authService.isSignedIn()) {
      await _authService.signInAnonymously();
    }

    try {
      final docRef = await _firestore.collection('offers').add({
        ...offer.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': _authService.getCurrentUserId()
      });

      final newDoc = await docRef.get(); // geting the map
      final savedOffer = Offer.fromJosn(newDoc.data()!, documentId: newDoc.id);

      await _adminNotificationService.sendNotification(savedOffer);
      return savedOffer;
    } catch (e) {
      print("$e");
      rethrow;
    }
    ;
  }

  //send notificcation

  //update offer

  //delete offer

  // offerstatustoggle
}
