import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goalbudgettracker/models/contribution_model.dart';
import 'package:goalbudgettracker/widgets/edit_goal.dart';
import 'package:goalbudgettracker/widgets/new_contribution.dart';
import 'package:goalbudgettracker/models/goal_model.dart';
import 'package:goalbudgettracker/widgets/contribution_item_card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GoalDetailsScreen extends StatefulWidget {
  const GoalDetailsScreen(this.goalId, {super.key});
  final String goalId;

  @override
  State<GoalDetailsScreen> createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  late TooltipBehavior _tooltipBehavior;
  GoalModel? goalDetails;
  bool _showIndicator = true;

  @override
  void initState() {
    fetchGoalDetails(widget.goalId).then((fetchedGoal) async {
      setState(
        () {
          goalDetails = fetchedGoal;
          fetchChartData();
          _showIndicator = false;
        },
      );
    });

    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  void _openAddContributionOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: NewContribution(widget.goalId));
      },
      isDismissible: true,
      enableDrag: true,
    );
  }

  void _openEditGoalOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: EditGoal(goalId: widget.goalId));
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
          title: const Text("Goal Details"),
          actions: [
            IconButton(
              onPressed: _openEditGoalOverlay,
              icon: const Icon(
                Icons.edit,
                size: 30,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: _openAddContributionOverlay,
              icon: const Icon(
                Icons.add,
                size: 30,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(15),
          child: _showIndicator
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(children: [
                  Center(
                    child: Text(
                      '${goalDetails?.title}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple),
                    ),
                  ),
                  _buildChart(),
                  !(goalDetails == null)
                      ? (goalDetails?.contributions.length == 0)
                          ? const Center(
                              child: Text(
                              "No Contributions",
                              style: TextStyle(fontSize: 20),
                            ))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: goalDetails?.contributions.length,
                              itemBuilder: (context, index) {
                                final contribution =
                                    goalDetails!.contributions[index];

                                return ContributionItemCard(ContributionModel(
                                  id: contribution['id'],
                                  amount: (contribution['amount'] as num)
                                          .toDouble() ??
                                      0.0,
                                  date: contribution['date'].toDate(),
                                ));
                              },
                            )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ]),
        )));
  }

  Widget _buildContributionsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc("jxzXfmMJUO9n1JsDwtPM")
          .collection('Goals')
          .doc(widget.goalId)
          .collection('contributions')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final List<QueryDocumentSnapshot> contributions = snapshot.data!.docs;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: contributions.length,
            itemBuilder: (context, index) {
              final contribution = contributions[index];
              return ContributionItemCard(
                ContributionModel(
                  id: contribution['id'],
                  amount: (contribution['amount'] as num).toDouble() ?? 0.0,
                  date: contribution['date'].toDate(),
                ),
              );
            },
          );
        } else {
          return Text('No contributions available');
        }
      },
    );
  }

  Widget _buildChart() {
    return FutureBuilder<List<GDPData>>(
      future: fetchChartData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return SfCircularChart(
            legend: Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            tooltipBehavior: _tooltipBehavior,
            series: <CircularSeries>[
              PieSeries<GDPData, String>(
                dataSource: snapshot.data!,
                xValueMapper: (GDPData data, _) => data.continent,
                yValueMapper: (GDPData data, _) => data.gdp,
                dataLabelSettings: DataLabelSettings(isVisible: true),
                enableTooltip: true,
              )
            ],
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }

  Future<List<GDPData>> fetchChartData() async {
    if (goalDetails != null) {
      return [
        GDPData('Target Amount', goalDetails!.targetAmount.toInt()),
        GDPData('Saved Amount', goalDetails!.savedAmount.toInt()),
      ];
    } else {
      return [];
    }
  }
}

class GDPData {
  GDPData(this.continent, this.gdp);
  final String continent;
  final int gdp;
}
