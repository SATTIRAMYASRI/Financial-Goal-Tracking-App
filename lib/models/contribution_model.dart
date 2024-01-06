import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ContributionModel {
  final String id;
  final double amount;
  final DateTime date;

   ContributionModel({
    id,
    required this.amount,
    required this.date,
  }) : id = id ?? Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date,
    };
  }
}

Future<void> updateSavedAmount(String goalId, double contributionAmount) async {
  try {
    final CollectionReference goalsCollection = FirebaseFirestore.instance
        .collection('user')
        .doc('jxzXfmMJUO9n1JsDwtPM')
        .collection('Goals');

    final DocumentReference goalDoc = goalsCollection.doc(goalId);

    final DocumentSnapshot goalSnapshot = await goalDoc.get();
    final double savedAmount =
        (goalSnapshot['savedamount'] ?? 0.0) + contributionAmount;

    await goalDoc.update({'savedamount': savedAmount});

    print('Saved amount updated successfully for goal ID: $goalId');
  } catch (e) {
    print('Error updating saved amount for goal: $e');
  }
}

Future<void> addContributionToGoal(
    String goalId, ContributionModel contribution) async {
  try {
    final CollectionReference goalsCollection = FirebaseFirestore.instance
        .collection('user')
        .doc('jxzXfmMJUO9n1JsDwtPM')
        .collection('Goals');
    final DocumentReference goalDoc = goalsCollection.doc(goalId);
    final DocumentSnapshot goalSnapshot = await goalDoc.get();

    final List<Map<String, dynamic>> existingContributions =
        List<Map<String, dynamic>>.from(goalSnapshot['contributions'] ?? []);

    existingContributions.add(contribution.toJson());

    await goalDoc.update({'contributions': existingContributions});

    await updateSavedAmount(goalId, contribution.amount);
    print('Contribution added successfully to goal ID: $goalId');
  } catch (e) {
    print('Error adding contribution to goal: $e');
  }
}


