import 'package:e_she_book/book_selection_page.dart';
import 'package:e_she_book/certificate_page.dart';
import 'package:e_she_book/topics/emergency_handling_english/emergency_preparedness.dart';
import 'package:e_she_book/topics/emergency_handling_english/emergency_response.dart';
import 'package:e_she_book/topics/emergency_handling_english/emergency_types.dart';
import 'package:e_she_book/topics/emergency_handling_english/introduction_to_emergency.dart';
import 'package:e_she_book/topics/emergency_handling_english/post_emergency_action.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/welcome.dart';

class EmergencyHandlingEnglish extends StatefulWidget {
  @override
  _EmergencyHandlingEnglishState createState() => _EmergencyHandlingEnglishState();
}

class _EmergencyHandlingEnglishState extends State<EmergencyHandlingEnglish> {
  Map<String, dynamic> topicProgress = {};
  bool allTopicsCompleted = false;
  String userName = "";

  final List<Map<String, dynamic>> topics = [
    {"title": "Introduction to Emergency", "page": IntroductionToEmergency(), "key": "IntroductionToEmergency"},
    {"title": "Types of Emergency", "page": EmergencyTypes(), "key": "TypesOfEmergency"},
    {"title": "Emergency Preparedness", "page": EmergencyPreparedness(), "key": "EmergencyPreparedness"},
    {"title": "Emergency Response", "page": EmergencyResponse(), "key": "EmergencyResponse"},
    {"title": "Post-Emergency Actions", "page": PostEmergencyActions(), "key": "PostEmergencyActions"},
  ];

  @override
  void initState() {
    super.initState();
    _loadTopicProgress();
  }

  Future<void> _loadTopicProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> progress = {};
    bool allCompleted = true;

    for (var topic in topics) {
      String key = topic["key"];
      bool isCompleted = prefs.getBool('Completed_$key') ?? false;
      int quizScore = prefs.getInt('QuizScore_$key') ?? -1;
      progress[key] = {"completed": isCompleted, "score": quizScore};
      if (!isCompleted || quizScore < 3) allCompleted = false;
    }

    String storedUserName = prefs.getString('user_name') ?? "User";

    setState(() {
      topicProgress = progress;
      allTopicsCompleted = allCompleted;
      userName = storedUserName;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        title: Text("🚨 Emergency Handling - English"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BookSelectionPage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Welcome()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildProgressBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: topics.length,
              itemBuilder: (context, index) {
                final topic = topics[index];
                final key = topic["key"];
                final isCompleted = topicProgress[key]?['completed'] ?? false;
                final score = topicProgress[key]?['score'] ?? -1;
                return _buildTopicCard(context, topic["title"], topic["page"], isCompleted, score, key);
              },
            ),
          ),
          if (allTopicsCompleted)
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.workspace_premium, color: Colors.white),
                label: const Text("Generate Certificate", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CertificatePage(
                        userName: userName,
                        topicProgress: topicProgress,
                        bookId: "Emergency Handling",
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

  Widget _buildProgressBar() {
    int completedTopics = topicProgress.values.where((t) => t['completed'] == true).length;
    int totalTopics = topics.length;
    double progress = completedTopics / totalTopics;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Progress: $completedTopics / $totalTopics", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              color: Colors.deepOrange,
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, String title, Widget page, bool isCompleted, int quizScore, String key) {
    final currentIndex = topics.indexWhere((element) => element["key"] == key);
    bool isAccessible = true;

    if (currentIndex > 0) {
      final prevKey = topics[currentIndex - 1]["key"];
      final prevCompleted = topicProgress[prevKey]?['completed'] ?? false;
      final prevScore = topicProgress[prevKey]?['score'] ?? -1;
      if (!prevCompleted || prevScore < 3) isAccessible = false;
    }

    final statusText = quizScore >= 0
        ? "✅ Score: $quizScore / 5"
        : isCompleted
        ? "✔ Completed"
        : "🔴 Not Completed";

    final statusColor = quizScore >= 0
        ? Colors.green
        : isCompleted
        ? Colors.blue
        : Colors.redAccent;

    return Opacity(
      opacity: isAccessible ? 1.0 : 0.5,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.deepOrange),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
          ),
          trailing: Icon(
            isAccessible ? Icons.arrow_forward_ios : Icons.lock,
            color: isAccessible ? Colors.black54 : Colors.grey,
          ),
          onTap: isAccessible
              ? () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => page),
            ).then((_) => _loadTopicProgress());
          }
              : () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Please complete the previous topic with a score of 3 or above.")),
            );
          },
        ),
      ),
    );
  }
}
