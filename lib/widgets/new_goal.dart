import 'package:flutter/material.dart';
import 'package:goalbudgettracker/enums/enum.dart';
import 'package:goalbudgettracker/gobal_functions.dart';
import 'package:goalbudgettracker/models/goal_model.dart';

class NewGoal extends StatefulWidget {
  const NewGoal({super.key});

  @override
  State<NewGoal> createState() => _NewGoalState();
}

class _NewGoalState extends State<NewGoal> {
  final _titleController = TextEditingController();
  final _targetamountController = TextEditingController();
  final _savedamountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.Critical;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final lastDate = DateTime(now.year + 20, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: lastDate,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitGoalData() {
    final enteredTargetAmount = double.tryParse(_targetamountController.text);
    final enteredSavedAmount = double.tryParse(_savedamountController.text);
    final amountIsInvalid =
        (enteredTargetAmount == null || enteredTargetAmount <= 0) ||
            (enteredSavedAmount == null || enteredSavedAmount < 0);
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered.'),
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
    createUserGoal(GoalModel(
      title: _titleController.text,
      targetAmount: double.tryParse(_targetamountController.text) ?? 0.0,
      savedAmount: double.tryParse(_savedamountController.text) ?? 0.0,
      date: _selectedDate!,
      category: _selectedCategory.name,
      contributions: [],
    ));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetamountController.dispose();
    _savedamountController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Goal Title",
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple),
                ),
              ),
              controller: _titleController,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _targetamountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: '₹',
                label: Text('Target Amount'),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _savedamountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: '₹',
                label: Text('Saved Amount'),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: DropdownButton(
                    value: _selectedCategory,
                    items: Category.values
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(
                              category.name.toUpperCase(),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),
                // const SizedBox(width: ),
                Expanded(
                  child: Row(
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
                    onPressed: _submitGoalData,
                    child: const Text('Save Goal'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
