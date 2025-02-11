import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GymProgramsPage(),
  ));
}

class GymProgramsPage extends StatelessWidget {
  // Dummy data for the programs
  final Map<String, List<Map<String, String>>> programDetails = {
    'Strength Training': [
      {'exercise': 'Squats', 'sets': '4', 'reps': '12', 'time': '30 min'},
      {'exercise': 'Deadlifts', 'sets': '3', 'reps': '10', 'time': '25 min'},
      {'exercise': 'Bench Press', 'sets': '4', 'reps': '12', 'time': '20 min'},
    ],
    'Cardio Program': [
      {'exercise': 'Running', 'sets': '3', 'reps': '5 km', 'time': '30 min'},
      {'exercise': 'Cycling', 'sets': '3', 'reps': '20 km', 'time': '40 min'},
      {'exercise': 'Jump Rope', 'sets': '4', 'reps': '10 min', 'time': '15 min'},
    ],
    'Yoga Sessions': [
      {'exercise': 'Sun Salutation', 'sets': '5', 'reps': '5 min', 'time': '15 min'},
      {'exercise': 'Warrior Pose', 'sets': '4', 'reps': '5 min', 'time': '20 min'},
      {'exercise': 'Downward Dog', 'sets': '5', 'reps': '5 min', 'time': '20 min'},
    ],
    'HIIT Workouts': [
      {'exercise': 'Burpees', 'sets': '4', 'reps': '30', 'time': '10 min'},
      {'exercise': 'Mountain Climbers', 'sets': '4', 'reps': '40', 'time': '15 min'},
      {'exercise': 'Jumping Jacks', 'sets': '4', 'reps': '50', 'time': '10 min'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Header Background Gradient
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade300, Colors.orange.shade800],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Gym Programs Section
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      children: [
                        _buildProgramTile(
                          icon: Icons.fitness_center,
                          title: 'Strength Training',
                          subtitle: 'Build muscle and improve overall strength.',
                          onTap: () => _navigateToProgramDetails(context, 'Strength Training'),
                        ),
                        _buildProgramTile(
                          icon: Icons.run_circle,
                          title: 'Cardio Program',
                          subtitle: 'Improve endurance and burn calories.',
                          onTap: () => _navigateToProgramDetails(context, 'Cardio Program'),
                        ),
                        _buildProgramTile(
                          icon: Icons.self_improvement,
                          title: 'Yoga Sessions',
                          subtitle: 'Enhance flexibility and reduce stress.',
                          onTap: () => _navigateToProgramDetails(context, 'Yoga Sessions'),
                        ),
                        _buildProgramTile(
                          icon: Icons.accessibility_new,
                          title: 'HIIT Workouts',
                          subtitle: 'High-intensity interval training for fast results.',
                          onTap: () => _navigateToProgramDetails(context, 'HIIT Workouts'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Function() onTap,
  }) {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        leading: Icon(icon, size: 30, color: Colors.orange.shade600),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.orange.shade800,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: Icon(Icons.arrow_forward, color: Colors.orange.shade600),
        onTap: onTap,
      ),
    );
  }

  void _navigateToProgramDetails(BuildContext context, String program) {
    final details = programDetails[program]!;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProgramDetailsPage(
          programName: program,
          exercises: details,
        ),
      ),
    );
  }
}

class ProgramDetailsPage extends StatelessWidget {
  final String programName;
  final List<Map<String, String>> exercises;

  ProgramDetailsPage({required this.programName, required this.exercises});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(programName),
        backgroundColor: Colors.orange.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: exercises.map<Widget>((exercise) {
            return Card(
              elevation: 5.0,
              margin: EdgeInsets.symmetric(vertical: 6.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                title: Text(
                  exercise['exercise']!,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Sets: ${exercise['sets']} - Reps: ${exercise['reps']} - Time: ${exercise['time']}',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                onTap: () => _showEditExerciseDialog(context, exercise),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Method to show the edit exercise dialog
  void _showEditExerciseDialog(BuildContext context, Map<String, String> exercise) {
    final TextEditingController setsController = TextEditingController(text: exercise['sets']);
    final TextEditingController repsController = TextEditingController(text: exercise['reps']);
    final TextEditingController timeController = TextEditingController(text: exercise['time']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Exercise: ${exercise['exercise']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: setsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Sets'),
              ),
              TextField(
                controller: repsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Reps'),
              ),
              TextField(
                controller: timeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Time'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Save the changes to the exercise
                exercise['sets'] = setsController.text;
                exercise['reps'] = repsController.text;
                exercise['time'] = timeController.text;
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context), // Close the dialog without saving
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
