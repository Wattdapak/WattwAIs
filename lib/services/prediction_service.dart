import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

import "package:wattwais/models/bill_model.dart";

//for saving prediction results into Firestore.
class PredictionService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  //save prediction record to Firestore under the current user.
  //
  // Parameters:
  // - [predictionTarget]: "current_month" or "next_month"
  // - [budget]: the monthly budget entered by the user
  // - [bills]: list of BillModel objects representing the 6 months of bills
 
  // - Exception if the user is not authenticated
  static Future<void> savePrediction({
    required String predictionTarget,
    required double budget,
    required List<BillModel> bills,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('bill_predictions')
        .add({
      'prediction_target': predictionTarget,
      'budget': budget,
      'bills': bills.map((bill) => bill.toMap()).toList(),
      'created_at': FieldValue.serverTimestamp(),
    });
  }
}
