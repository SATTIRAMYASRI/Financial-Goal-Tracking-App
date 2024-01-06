import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class GoalModel {
  final String id;
  final String title;
  final double targetAmount;
  final double savedAmount;
  final DateTime date;
  final String category;
  final List<Map<String, dynamic>> contributions;

  GoalModel({
    id,
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.date,
    required this.category,
    required this.contributions,
  }) : id = id ?? Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'targetamount': targetAmount,
      'savedamount': savedAmount,
      'date': date,
      'category': category,
      'contributions': contributions,
    };
  }
}


Future<void> createUserGoal(GoalModel goal) async {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');
  print(goal);
  try {
    await userCollection
        .doc("jxzXfmMJUO9n1JsDwtPM")
        .collection('Goals')
        .doc(goal.id)
        .set(goal.toJson());
    print('Goal added successfully with ID: ${goal.id}');
  } catch (e) {
    print('Error adding goal: $e');
  }
}

Future<void> updateGoalDetails(String goalId, GoalModel updatedValues) async {
  try {
    final DocumentReference goalReference = FirebaseFirestore.instance
        .collection('user')
        .doc("jxzXfmMJUO9n1JsDwtPM")
        .collection('Goals')
        .doc(goalId);

    await goalReference.update(updatedValues.toJson());

    print('Goal details updated successfully for ID: $goalId');
  } catch (e) {
    print('Error updating goal details: $e');
  }
}

Future<void> deleteGoal(String goalId) async {
  try {
    final DocumentReference goalReference = FirebaseFirestore.instance
        .collection('user')
        .doc("jxzXfmMJUO9n1JsDwtPM")
        .collection('Goals')
        .doc(goalId);

    await goalReference.delete();

    print('Goal deleted successfully for ID: $goalId');
  } catch (e) {
    print('Error deleting goal: $e');
  }
}

Future<GoalModel?> fetchGoalDetails(String goalId) async {
  try {
    DocumentSnapshot goalSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc("jxzXfmMJUO9n1JsDwtPM")
        .collection('Goals')
        .doc(goalId)
        .get();
    
    if (goalSnapshot.exists) {
      Map<String, dynamic> data = goalSnapshot.data() as Map<String, dynamic>;

      
      GoalModel goal = GoalModel(
        id: data['id'],
        title: data['title'],
        targetAmount: data['targetamount'],
        savedAmount: data['savedamount'],
        date: data['date'].toDate(),
        category: data['category'],
        contributions: List<Map<String, dynamic>>.from(data['contributions']),
      );

      return goal;
    } else {
      print('Goal not found with ID: $goalId');
      return null;
    }
  } catch (e) {
    print('Error fetching goal details: $e');
    return null;
  }
}

// void main() async {
//   GoalModel newGoal = GoalModel(
//     title: 'Buy a house',
//     targetAmount: 150000,
//     savedAmount: 1000,
//     date: DateTime.now(),
//     category: 'Critical',
//     contributions: [
//       {"amount": 10000, "date": "2024-01-01"},
//       {"amount": 15000, "date": "2024-01-15"},
//     ],
//   );
//   await createUserGoal(newGoal);
// }

