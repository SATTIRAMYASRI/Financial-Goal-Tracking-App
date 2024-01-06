import 'package:flutter/material.dart';
import 'package:goalbudgettracker/gobal_functions.dart';
import 'package:goalbudgettracker/models/contribution_model.dart';

class ContributionItemCard extends StatelessWidget {
  const ContributionItemCard(this.contribution, {super.key});

  final ContributionModel contribution;

  @override
  Widget build(BuildContext context) {
    return Card(
      color:Colors.purple.shade200,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Row(
          children: [
            Text('₹ ${contribution.amount.toStringAsFixed(2)}'),
            const Spacer(),
            Text(GlobalFunctions().formattedDate(contribution.date)),
          ],
        ),
      ),
    );
  }
}
