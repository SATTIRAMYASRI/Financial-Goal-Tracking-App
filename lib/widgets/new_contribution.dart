import 'package:flutter/material.dart';
import 'package:goalbudgettracker/gobal_functions.dart';
import 'package:goalbudgettracker/models/contribution_model.dart';

class NewContribution extends StatefulWidget {
  const NewContribution(this.goalId, {super.key});
  final String goalId;

  @override
  State<NewContribution> createState() => _NewContributionState();
}

class _NewContributionState extends State<NewContribution> {
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
  
  void _submitContributionData() {
    final enteredAmount= double.tryParse(_amountController.text);
    final amountIsInvalid =
        (enteredAmount == null || enteredAmount <= 0);
    if (
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid amount and date was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }
    addContributionToGoal(
                        widget.goalId,
                        ContributionModel(amount: 
                        double.tryParse(_amountController.text) ?? 0.0
                        , date: _selectedDate!)
                      );
    Navigator.pop(context);
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
        child: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: '₹',
                label: Text('Amount'),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _presentDatePicker,
                  icon: const Icon(
                    Icons.calendar_month,
                  ),
                ),
                Text(
                  _selectedDate == null
                      ? 'Unset'
                      : GlobalFunctions().formattedDate(_selectedDate!),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    autofocus: true,
                    onPressed: _submitContributionData,
                    child: const Text('Save'),
                  ),
                ),
              ],
            )
          ],
        )));
  }
}
