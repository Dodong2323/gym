import 'package:flutter/material.dart';
import 'dart:math';

class MembersProgressPage extends StatelessWidget {
  final List<String> members = [
    'John Doe',
    'Jane Smith',
    'Michael Johnson',
    'Emily Davis',
    'Chris Brown',
  ];

  final Map<String, List<Map<String, dynamic>>> memberProgress = {
    'John Doe': [
      {'program': 'Push Day', 'lbs': 120, 'reps': 10, 'date': '2024-01-01'},
      {'program': 'Leg Day', 'lbs': 150, 'reps': 8, 'date': '2024-01-03'},
      {'program': 'Cardio', 'lbs': 130, 'reps': 0, 'date': '2024-01-05'},
      {'program': 'Pull Day', 'lbs': 140, 'reps': 12, 'date': '2024-01-07'},
      {'program': 'Push Day', 'lbs': 155, 'reps': 10, 'date': '2024-01-09'},
      {'program': 'Leg Day', 'lbs': 160, 'reps': 8, 'date': '2024-01-10'},
      {'program': 'Pull Day', 'lbs': 165, 'reps': 12, 'date': '2024-01-12'},
    ],
    'Jane Smith': [
      {'program': 'Push Day', 'lbs': 95, 'reps': 12, 'date': '2024-01-02'},
      {'program': 'Leg Day', 'lbs': 140, 'reps': 10, 'date': '2024-01-04'},
      {'program': 'Cardio', 'lbs': 110, 'reps': 0, 'date': '2024-01-06'},
      {'program': 'Pull Day', 'lbs': 130, 'reps': 14, 'date': '2024-01-08'},
      {'program': 'Push Day', 'lbs': 140, 'reps': 12, 'date': '2024-01-10'},
      {'program': 'Leg Day', 'lbs': 145, 'reps': 10, 'date': '2024-01-11'},
      {'program': 'Pull Day', 'lbs': 150, 'reps': 14, 'date': '2024-01-13'},
    ],
    'Michael Johnson': [
      {'program': 'Push Day', 'lbs': 160, 'reps': 10, 'date': '2024-01-02'},
      {'program': 'Leg Day', 'lbs': 170, 'reps': 8, 'date': '2024-01-03'},
      {'program': 'Cardio', 'lbs': 140, 'reps': 0, 'date': '2024-01-05'},
      {'program': 'Pull Day', 'lbs': 180, 'reps': 12, 'date': '2024-01-07'},
      {'program': 'Push Day', 'lbs': 165, 'reps': 10, 'date': '2024-01-09'},
      {'program': 'Leg Day', 'lbs': 175, 'reps': 8, 'date': '2024-01-10'},
      {'program': 'Pull Day', 'lbs': 185, 'reps': 12, 'date': '2024-01-12'},
    ],
    'Emily Davis': [
      {'program': 'Push Day', 'lbs': 100, 'reps': 15, 'date': '2024-01-01'},
      {'program': 'Leg Day', 'lbs': 130, 'reps': 12, 'date': '2024-01-03'},
      {'program': 'Cardio', 'lbs': 115, 'reps': 0, 'date': '2024-01-05'},
      {'program': 'Pull Day', 'lbs': 125, 'reps': 14, 'date': '2024-01-07'},
      {'program': 'Push Day', 'lbs': 110, 'reps': 15, 'date': '2024-01-09'},
      {'program': 'Leg Day', 'lbs': 135, 'reps': 12, 'date': '2024-01-10'},
      {'program': 'Pull Day', 'lbs': 130, 'reps': 14, 'date': '2024-01-12'},
    ],
    'Chris Brown': [
      {'program': 'Push Day', 'lbs': 135, 'reps': 10, 'date': '2024-01-02'},
      {'program': 'Leg Day', 'lbs': 155, 'reps': 8, 'date': '2024-01-04'},
      {'program': 'Cardio', 'lbs': 120, 'reps': 0, 'date': '2024-01-06'},
      {'program': 'Pull Day', 'lbs': 145, 'reps': 12, 'date': '2024-01-08'},
      {'program': 'Push Day', 'lbs': 150, 'reps': 10, 'date': '2024-01-10'},
      {'program': 'Leg Day', 'lbs': 160, 'reps': 8, 'date': '2024-01-11'},
      {'program': 'Pull Day', 'lbs': 155, 'reps': 12, 'date': '2024-01-13'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 10.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 12.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 15.0),
                            leading: Icon(
                              Icons.person,
                              color: Colors.orange.shade600,
                              size: 30,
                            ),
                            title: Text(
                              members[index],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.orange.shade800,
                              ),
                            ),
                            subtitle: Text(
                              'Training progress: Intermediate',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward,
                              color: Colors.orange.shade600,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MemberProgressDetailPage(
                                    memberName: members[index],
                                    progressData:
                                        memberProgress[members[index]] ?? [],
                                  ),
                                ),
                              );
                            },
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
}

class MemberProgressDetailPage extends StatelessWidget {
  final String memberName;
  final List<Map<String, dynamic>> progressData;

  MemberProgressDetailPage({
    required this.memberName,
    required this.progressData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$memberName Progress'),
        backgroundColor: Colors.orange.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Graph Container
            Expanded(
              flex: 2,
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: CustomPaint(
                  painter: GraphPainter(progressData),
                ),
              ),
            ),
            SizedBox(width: 16),

            // Progress Details
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Workout Details',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),
                  SizedBox(height: 10),
                  for (var data in progressData)
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${data['program']} - ${data['lbs']} lbs',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  final List<Map<String, dynamic>> progressData;

  GraphPainter(this.progressData);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final Paint pointPaint = Paint()
      ..strokeWidth = 6
      ..style = PaintingStyle.fill;

    final TextStyle labelStyle = TextStyle(
      color: Colors.black,
      fontSize: 12,
    );

    final double padding = 20;
    final double chartWidth = size.width - 2 * padding;
    final double chartHeight = size.height - 2 * padding;

    final double maxLbs = progressData
        .map((data) => data['lbs'] as double)
        .reduce(max);

    final List<Offset> points = [];

    for (int i = 0; i < progressData.length; i++) {
      final double x = padding + (i / (progressData.length - 1)) * chartWidth;
      final double y = size.height - 
          padding - 
          (progressData[i]['lbs'] / maxLbs) * chartHeight;

      points.add(Offset(x, y));
    }

    // Color each program line differently
    Map<String, Color> programColors = {
      'Push Day': Colors.blue,
      'Leg Day': Colors.red,
      'Cardio': Colors.green,
      'Pull Day': Colors.purple,
    };

    for (int i = 0; i < points.length - 1; i++) {
      linePaint.color = programColors[progressData[i]['program']] ?? Colors.black;
      canvas.drawLine(points[i], points[i + 1], linePaint);
    }

    for (int i = 0; i < points.length; i++) {
      final Offset point = points[i];
      canvas.drawCircle(point, 5, pointPaint);

      // Label position fix to avoid overflow
      final String label = '${progressData[i]['lbs']} lbs';
      final TextPainter textPainter = TextPainter(
        text: TextSpan(text: label, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      final double labelX = point.dx - textPainter.width / 2;
      final double labelY = point.dy - textPainter.height - 10;

      // Ensure the label stays within the bounds
      if (labelX >= padding && labelX + textPainter.width <= size.width - padding) {
        textPainter.paint(canvas, Offset(labelX, labelY));
      }

      // Date position fix to avoid overflow
      final String date = progressData[i]['date'];
      final TextPainter datePainter = TextPainter(
        text: TextSpan(text: date, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      final double dateX = point.dx - datePainter.width / 2;
      final double dateY = point.dy + 5;

      // Ensure the date stays within the bounds
      if (dateX >= padding && dateX + datePainter.width <= size.width - padding) {
        datePainter.paint(canvas, Offset(dateX, dateY));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MembersProgressPage(),
  ));
}
