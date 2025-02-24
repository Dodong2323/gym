import 'package:flutter/material.dart';

class LogsProgressPage extends StatelessWidget {
  final List<Map<String, dynamic>> logs = [
    {
      "date": "Feb 12",
      "title": "Lower Day - Feb 12",
      "category": "Lower Body",
      "warmups": [
        {
          "name": "Warmup Squat",
          "sets": "1x20",
          "reps": [20]
        },
        {
          "name": "Warmup Hack Squat",
          "sets": "1x16",
          "weight": "25kg",
          "reps": [16]
        },
      ],
      "exercises": [
        {
          "name": "Hack Squat",
          "sets": "2x5",
          "weight": "65kg, 70kg each side",
          "reps": [5, 6]
        },
        {
          "name": "Smith RDL",
          "sets": "2x7",
          "weight": "30kg",
          "reps": [7, 7]
        },
        {
          "name": "Thigh Clapper",
          "sets": "2x7",
          "weight": "12th line",
          "reps": [7, 5]
        },
        {
          "name": "Leg Extension",
          "sets": "2x10",
          "weight": "+10kg, +15kg",
          "reps": [10, 8]
        },
        {
          "name": "Single Left Extension",
          "sets": "1x6",
          "weight": "55kg",
          "reps": [6]
        },
        {
          "name": "DB Shrugs",
          "sets": "2x7",
          "weight": "45kg",
          "reps": [7, 9]
        },
        {
          "name": "Calf Raises",
          "sets": "2x9",
          "weight": "90kg each side",
          "reps": [9, 9]
        },
        {
          "name": "Single Calf Raises",
          "sets": "1x3",
          "weight": "50kg each side",
          "reps": [3]
        },
      ],
    },
    {
      "date": "Feb 13",
      "title": "Upper Day - Feb 13",
      "category": "Upper Body",
      "warmups": [
        {
          "name": "Warmup Machine Flies",
          "sets": "1x13",
          "weight": "9th line",
          "reps": [13]
        },
        {
          "name": "Warmup Incline DB Press",
          "sets": "1x17",
          "weight": "15kg",
          "reps": [17]
        },
        {
          "name": "Warmup Lat Pullover",
          "sets": "1x13",
          "weight": "7th line",
          "reps": [13]
        },
        {
          "name": "Warmup Cable Mid Row",
          "sets": "1x13",
          "weight": "30kg",
          "reps": [13]
        },
      ],
      "exercises": [
        {
          "name": "Incline DB Chest Press",
          "sets": "2x6",
          "weight": "30kg",
          "reps": [6, 6]
        },
        {
          "name": "Incline Machine Flies",
          "sets": "1x6",
          "weight": "27.5kg each side",
          "reps": [6]
        },
        {
          "name": "DB Shoulder Press",
          "sets": "1x4",
          "weight": "27.5kg",
          "reps": [4]
        },
        {
          "name": "Cable Mid Grip Row",
          "sets": "2x7, 10",
          "weight": "65kg",
          "reps": [7, 10]
        },
        {
          "name": "Cable Single Lat Pullover",
          "sets": "1x10 left, 10 right",
          "weight": "35kg",
          "reps": [10, 10]
        },
        {
          "name": "Cable Lat Pullovers",
          "sets": "1x10",
          "weight": "10th line",
          "reps": [10]
        },
        {
          "name": "Reverse Flies",
          "sets": "2x11, 10",
          "weight": "11th line",
          "reps": [11, 10]
        },
        {
          "name": "Lateral Raises",
          "sets": "2x11, 10",
          "weight": "45kg",
          "reps": [11, 10]
        },
        {
          "name": "Carter Extensions",
          "sets": "2x9, 5 left and 8, 4 right",
          "weight": "5th line, 6th line",
          "reps": [9, 5, 8, 4]
        },
        {
          "name": "Bicep Curl",
          "sets": "2x11, 9",
          "weight": "30kg",
          "reps": [11, 9]
        },
      ],
    },
  ];

  LogsProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Log and Progress",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
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
                log['title'],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Tap to view progress",
                  style: TextStyle(color: Colors.grey)),
              trailing:
                  const Icon(Icons.arrow_forward_ios, color: Colors.orange),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProgressDetailPage(log: log)),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProgressDetailPage extends StatelessWidget {
  final Map<String, dynamic> log;
  const ProgressDetailPage({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("${log['category']} - ${log['date']}",
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text("Exercises for ${log['date']}",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          ...log['warmups']
              .map<Widget>((exercise) => _buildExerciseCard(exercise))
              .toList(),
          ...log['exercises']
              .map<Widget>((exercise) => _buildExerciseCard(exercise))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(Map<String, dynamic> exercise) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: ListTile(
        title: Text(exercise["name"],
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        subtitle: Text(
            "Sets: ${exercise["sets"]}\nReps: ${exercise["reps"].join(", ")}${exercise.containsKey("weight") ? "\nWeight: ${exercise["weight"]}" : ""}",
            style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}
