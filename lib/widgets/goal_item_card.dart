import 'package:flutter/material.dart';
import 'package:goalbudgettracker/constants/category_icons.dart';
import 'package:goalbudgettracker/gobal_functions.dart';
import 'package:goalbudgettracker/models/goal_model.dart';

class GoalItemCard extends StatelessWidget {
  const GoalItemCard(this.goal, {super.key});

  final GoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(goal.title,
            style:const TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('₹ ${goal.targetAmount.toStringAsFixed(2)}'),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[goal.category]??Icons.add),
                    const SizedBox(width: 8),
                    Text(GlobalFunctions().formattedDate(goal.date)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
