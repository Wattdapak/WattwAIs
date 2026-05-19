import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

import "package:wattwais/models/appliance_model.dart";

//manage appliances in Firestore
//load, save, update, and delete appliances
class ApplianceService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  //load appliances
  static Future<List<ApplianceModel>> loadAppliances() async {
    final user = _auth.currentUser;

    if (user == null) {
      return [];
    }

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('appliances')
        .get();

    return snapshot.docs.map((doc) {
      return ApplianceModel.fromMap(doc.id, doc.data());
    }).toList();
  }

  //save or update appliance
  static Future<void> saveAppliance(ApplianceModel appliance) async {
    final user = _auth.currentUser;

    if (user == null) return;

    final collection = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('appliances');

    if (appliance.id.isEmpty) {
      await collection.doc().set(appliance.toMap());
    } else {
      await collection.doc(appliance.id).set(appliance.toMap());
    }
  }

  //delete appliance
  static Future<void> deleteAppliance(String applianceId) async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('appliances')
        .doc(applianceId)
        .delete();
  }
}
