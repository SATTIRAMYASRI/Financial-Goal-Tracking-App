import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goalbudgettracker/widgets/new_goal.dart';
import 'package:goalbudgettracker/models/goal_model.dart';
import 'package:goalbudgettracker/widgets/goal_details.dart';
import 'package:goalbudgettracker/widgets/goal_item_card.dart';

class Goals extends StatefulWidget {
  const Goals({super.key});

  @override
  State<Goals> createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  void _openAddGoalOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: const NewGoal(),
        );
      },
      isDismissible: true,
      enableDrag: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade100,
        title: const Text('Budget Tracker',style: TextStyle(fontSize: 20),),
        actions: [
          IconButton(
            onPressed: _openAddGoalOverlay,
            icon: const Icon(Icons.add,size:30,color: Colors.black,),
          ),
        ],
      ),
      body: Column(
        children: [
          const Text("Your Goals",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.purple,),),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('user')
                    .doc("jxzXfmMJUO9n1JsDwtPM")
                    .collection('Goals')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            QueryDocumentSnapshot<Map<String, dynamic>>? goal =
                                snapshot.data?.docs[index];

                            return Dismissible(
                              key:UniqueKey(),
                              onDismissed: (direction) {
                                deleteGoal(goal?['id']).then((_) {
                                  setState(() {});
                                });
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text('Goal deleted.'),
                                  ),
                                );
                              },
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GoalDetailsScreen(goal?['id'])),
                                  );
                                },
                                child: GoalItemCard(GoalModel(
                                  id: goal?['id'],
                                  title: goal?['title'],
                                  targetAmount: goal?['targetamount'],
                                  savedAmount: goal?['savedamount'],
                                  date: goal?['date'].toDate(),
                                  category: goal?['category'],
                                  contributions:
                                      List<Map<String, dynamic>>.from(
                                          goal?['contributions']),
                                )),
                              ),
                            );
                          }),
                    );
                  } else {
                    return const Center(child: Text("No data!"));
                  }
                }),
          )
        ],
      ),
    );
  }
}
