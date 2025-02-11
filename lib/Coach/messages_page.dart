import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  final List<Map<String, String>> messages = [
    {"name": "Coach Alex", "message": "Great job in today's session!", "time": "10:30 AM"},
    {"name": "Coach Mia", "message": "Remember to hydrate well after your workout.", "time": "9:15 AM"},
    {"name": "Coach John", "message": "Your next session is scheduled for tomorrow.", "time": "8:50 AM"},
    {"name": "Coach Emily", "message": "Please check the updated gym program.", "time": "Yesterday"},
    {"name": "Coach Mike", "message": "Keep up the good work!", "time": "Yesterday"},
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
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return Card(
                          elevation: 6.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange.shade600,
                              child: Text(
                                message['name']![6],
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(
                              message['name']!,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Text(
                              message['message']!,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            trailing: Text(
                              message['time']!,
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(coachName: message['name']!),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality for member to compose a new message to a coach
        },
        backgroundColor: Colors.orange.shade600,
        child: Icon(Icons.add),
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  final String coachName;

  ChatPage({required this.coachName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom Header without AppBar
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.orange.shade600,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Text(
              'Chat with $coachName',
              style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Conversation with $coachName',
                style: TextStyle(fontSize: 20, color: Colors.grey.shade800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MessagesPage(),
  ));
}
