import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:table_calendar/table_calendar.dart';

class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Today's Page")),
      body: Center(
        child: Text(
          "Noynay.homo.com.",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class LogsProgressPage extends StatelessWidget {
  LogsProgressPage({Key? key}) : super(key: key);

  final Random _random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Progress Logs"),
        backgroundColor: Colors.grey[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStreakTracker(),
            const SizedBox(height: 20),
            _buildWorkoutCalendar(context),
            const SizedBox(height: 20),
            _buildAnalyticsProgram(),
            const SizedBox(height: 20),
            _buildAnalyticsWeight(),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakTracker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "LOG AND PROGRESS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            Stack(
              alignment: Alignment.center,
              children: [
                // Thicker Orange Background Arc
                SizedBox(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(
                    value: 1, // Full arc background
                    strokeWidth: 10,
                    backgroundColor: Colors.orange.shade700,
                    valueColor:
                        const AlwaysStoppedAnimation(Colors.transparent),
                  ),
                ),
                // Foreground Progress Indicator
                SizedBox(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(
                    value: 0, // No progress
                    strokeWidth: 10,
                    valueColor: const AlwaysStoppedAnimation(Colors.black),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                // Centered Text
                Column(
                  children: const [
                    Text(
                      "0",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "/3 days",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text("No streak", style: TextStyle(color: Colors.white54)),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutCalendar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black, // Match background
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with Dropdown Arrow
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Workout Calendar",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
          const SizedBox(height: 10),

          // Months Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text("Jan", style: TextStyle(color: Colors.white, fontSize: 12)),
              Text("Feb", style: TextStyle(color: Colors.white, fontSize: 12)),
              Text("March",
                  style: TextStyle(color: Colors.white, fontSize: 12)),
              Text("April",
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 5),

          // Grid with Day Labels + Calendar
          Column(
            children: List.generate(7, (row) {
              return Row(
                children: List.generate(15, (col) {
                  if (col == 0) {
                    // Left-side weekday labels
                    return Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      child: Text(
                        ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][row],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    );
                  }

                  return GestureDetector(
                    onTap: () {
                      _showCalendarPopup(context); // Opens bottom sheet on tap
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.grey[800], // Same color for all
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showCalendarPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            DateTime? selectedDay;
            DateTime today = DateTime.now(); // Get today's date

            return DraggableScrollableSheet(
              initialChildSize: 0.8, // Start at 80% height
              minChildSize: 0.3, // Allows dragging down to 30%
              maxChildSize: 1.0, // Allows full-screen expansion
              snap: true,
              snapSizes: [0.3, 0.6, 1.0], // Snap points
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Column(
                    children: [
                      // Drag Handle
                      Container(
                        width: 40,
                        height: 5,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(height: 10),

                      // Title
                      Text(
                        "Select a Date",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(color: Colors.grey),

                      // Vertical Scrollable Calendar
                      Expanded(
                        child: PageView.builder(
                          scrollDirection:
                              Axis.vertical, // Enables up/down scrolling
                          itemCount: 12, // Number of months
                          itemBuilder: (context, index) {
                            DateTime month =
                                DateTime(DateTime.now().year, index + 1, 1);
                            return SingleChildScrollView(
                              physics:
                                  NeverScrollableScrollPhysics(), // Disable internal scrolling
                              child: TableCalendar(
                                focusedDay: month,
                                firstDay: DateTime(DateTime.now().year, 1, 1),
                                lastDay: DateTime(DateTime.now().year, 12, 31),
                                calendarFormat: CalendarFormat.month,
                                availableGestures: AvailableGestures
                                    .none, // Disable left/right swipe
                                pageAnimationEnabled:
                                    false, // Use vertical PageView instead
                                headerStyle: HeaderStyle(
                                  titleCentered: true,
                                  formatButtonVisible:
                                      false, // Hide week/month toggle
                                  titleTextStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                daysOfWeekStyle: DaysOfWeekStyle(
                                  weekdayStyle: TextStyle(color: Colors.white),
                                  weekendStyle:
                                      TextStyle(color: Colors.redAccent),
                                ),
                                calendarStyle: CalendarStyle(
                                  defaultTextStyle:
                                      TextStyle(color: Colors.white),
                                  weekendTextStyle:
                                      TextStyle(color: Colors.redAccent),
                                  todayDecoration: BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.withOpacity(0.8),
                                        spreadRadius: 4,
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  selectedDecoration: BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                selectedDayPredicate: (day) {
                                  return isSameDay(selectedDay, day);
                                },
                                onDaySelected: (newSelectedDay, focusedDay) {
                                  setState(() {
                                    selectedDay = newSelectedDay;
                                  });

                                  // Check if the selected date is today
                                  if (isSameDay(newSelectedDay, today)) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewScreen(),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 20),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

// ✅ Make sure NewScreen is defined at the top level, not inside another class or function

  Widget _buildAnalyticsProgram() {
    return _buildAnalyticsContainer(
      "Analytics Program",
      [
        LineChartBarData(
          spots: [FlSpot(0, 50), FlSpot(1, 100), FlSpot(2, 75), FlSpot(3, 150)],
          isCurved: true,
          color: Colors.red,
          barWidth: 3,
          isStrokeCapRound: true,
        ),
        LineChartBarData(
          spots: [FlSpot(0, 30), FlSpot(1, 120), FlSpot(2, 60), FlSpot(3, 130)],
          isCurved: true,
          color: Colors.blue,
          barWidth: 3,
          isStrokeCapRound: true,
        ),
        LineChartBarData(
          spots: [FlSpot(0, 20), FlSpot(1, 80), FlSpot(2, 40), FlSpot(3, 100)],
          isCurved: true,
          color: Colors.green,
          barWidth: 3,
          isStrokeCapRound: true,
        ),
      ],
    );
  }

  Widget _buildAnalyticsWeight() {
    return _buildAnalyticsContainer(
      "Analytics Weight",
      [
        LineChartBarData(
          spots: [FlSpot(0, 60), FlSpot(1, 90), FlSpot(2, 120), FlSpot(3, 180)],
          isCurved: true,
          color: Colors.blue,
          barWidth: 3,
          isStrokeCapRound: true,
        ),
      ],
    );
  }

  Widget _buildAnalyticsContainer(
      String title, List<LineChartBarData> lineBarsData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: lineBarsData,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem("Workout", Colors.red),
              _buildLegendItem("Shoulder", Colors.green),
              _buildLegendItem("Triceps", Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Container(width: 12, height: 12, color: color),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
