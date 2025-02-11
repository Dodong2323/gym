import 'package:flutter/material.dart';

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
    {
      "date": "2025-01-06",
      "exercises": [
        {"name": "Bicep Curl", "sets": "4x12", "reps": [12, 12, 12, 12]},
        {"name": "Deadlift", "sets": "3x10", "reps": [10, 10, 10]},
      ],
    },
    {
      "date": "2025-01-05",
      "exercises": [
        {"name": "Leg Press", "sets": "3x15", "reps": [15, 15, 15]},
        {"name": "Plank", "sets": "3x60 seconds", "reps": []},
      ],
    },
  ];

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
                // Logs Section
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final log = logs[index];
                        return Card(
                          elevation: 10.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 12.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                            title: Text(
                              log['date']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.orange.shade800,
                              ),
                            ),
                            subtitle: Text(
                              'Tap to view progress',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward, color: Colors.orange.shade600),
                            onTap: () => _showDetails(context, log),
                          ),
                        );
                      },
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

  void _showDetails(BuildContext context, Map<String, dynamic> log) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Progress for ${log['date']}',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    ...log['exercises']!.map<Widget>((exercise) {
                      return Card(
                        elevation: 5.0,
                        margin: EdgeInsets.symmetric(vertical: 6.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          title: Text(
                            exercise['name']!,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            'Sets: ${exercise['sets']} - Reps: ${exercise['reps']!.join(', ')}',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,  // Use backgroundColor instead of primary
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LogsProgressPage(),
  ));
}
