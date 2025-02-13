import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LogsProgressPage extends StatelessWidget {
  final List<Map<String, dynamic>> logs = [
    {
      "date": "2025-01-08",
      "exercises": [
        {"name": "Lateral Raise", "sets": "3x15", "reps": [12, 12, 14]},
        {"name": "Push-up", "sets": "3x20", "reps": [20, 20, 20]},
      ],
    },
    {
      "date": "2025-01-07",
      "exercises": [
        {"name": "Lateral Raise", "sets": "3x15", "reps": [10, 11, 12]},
        {"name": "Squats", "sets": "4x20", "reps": [20, 20, 18, 20]},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<FlSpot> _generateOverviewChartData() {
      List<FlSpot> spots = [];
      for (int i = 0; i < logs.length; i++) {
        int totalReps = logs[i]["exercises"].fold(
            0, (sum, exercise) => sum + (exercise["reps"] as List<int>).reduce((a, b) => a + b));
        spots.add(FlSpot((i + 1).toDouble(), totalReps.toDouble()));
      }
      return spots.isNotEmpty ? spots : [const FlSpot(1, 0)];
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Log and Progress", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10)]
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LineChart(
                  LineChartData(
                    backgroundColor: Colors.grey[900],
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _generateOverviewChartData(),
                        isCurved: true,
                        color: Colors.blueAccent,
                        barWidth: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return Card(
                  color: Colors.grey[850],
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      log['date'],
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text("Tap to view progress", style: TextStyle(color: Colors.grey)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.orange),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProgressGraphPage(log: log)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressGraphPage extends StatelessWidget {
  final Map<String, dynamic> log;
  const ProgressGraphPage({Key? key, required this.log}) : super(key: key);

  List<FlSpot> _generateExerciseChartData() {
    List<FlSpot> spots = [];
    List<dynamic> exercises = log["exercises"];

    for (int i = 0; i < exercises.length; i++) {
      int highestRep = (exercises[i]["reps"] as List<int>).reduce((a, b) => a > b ? a : b);
      spots.add(FlSpot((i + 1).toDouble(), highestRep.toDouble()));
    }

    return spots.isNotEmpty ? spots : [const FlSpot(1, 0)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Progress - ${log['date']}", style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Exercises for ${log['date']}",
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: log['exercises'].length,
                itemBuilder: (context, index) {
                  final exercise = log['exercises'][index];
                  return Card(
                    color: Colors.grey[850],
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    child: ListTile(
                      title: Text(
                        exercise["name"],
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Sets: ${exercise["sets"]}\nReps: ${exercise["reps"].join(", ")}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: LineChart(
                    LineChartData(
                      backgroundColor: Colors.grey[900],
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _generateExerciseChartData(),
                          isCurved: true,
                          color: Colors.purpleAccent,
                          barWidth: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
