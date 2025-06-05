import 'package:e_she_book/book_selection_page.dart';
import 'package:e_she_book/topics/environment_safety_tamil/daily_and_eating_habits.dart';
import 'package:e_she_book/topics/environment_safety_tamil/energy_saving_and_usage.dart';
import 'package:e_she_book/topics/environment_safety_tamil/environmental_pollution_types.dart';
import 'package:e_she_book/topics/environment_safety_tamil/home_and_yard_practices.dart';
import 'package:e_she_book/topics/environment_safety_tamil/introduction_to_environment.dart';
import 'package:e_she_book/topics/environment_safety_tamil/save_the_environment.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/certificate_page.dart';

class EnvironmentalSafetyTamil extends StatefulWidget {
  @override
  _EnvironmentalSafetyTamilState createState() => _EnvironmentalSafetyTamilState();
}

class _EnvironmentalSafetyTamilState extends State<EnvironmentalSafetyTamil> {
  Map<String, dynamic> topicProgress = {};
  bool allTopicsCompleted = false;
  String userName = "";

  final List<Map<String, dynamic>> topics = [
    {"title": "தலைப்பு 1\nசுற்றுச்சூழல் அறிமுகம்", "page": IntroductionToEnvironmentTamilPage(), "key": "EnvTopic1"},
    {"title": "தலைப்பு 2\nசுற்றுச்சூழலை பாதுகாப்பது எப்படி", "page": SaveTheEnvironmentTamilPage(), "key": "EnvTopic2"},
    {"title": "தலைப்பு 3\nமாசுபாட்டின் வகைகள்", "page": EnvironmentalPollutionTypesTamilPage(), "key": "EnvTopic3"},
    {"title": "தலைப்பு 4\nதினசரி மற்றும் உணவு பழக்கங்கள்", "page": DailyAndEatingHabitsTamilPage(), "key": "EnvTopic4"},
    {"title": "தலைப்பு 5\nவீடு மற்றும் தோட்ட நடைமுறைகள்", "page": HomeAndYardPracticesTamilPage(), "key": "EnvTopic5"},
    // {"title": "தலைப்பு 6\nஆற்றல் சேமிப்பு மற்றும் பயன்பாடு", "page": EnergySavingAndUsageTamilPage(), "key": "EnvTopic6"},
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

      if (!isCompleted || quizScore < 3) {
        allCompleted = false;
      }
    }

    if (allCompleted && !(prefs.containsKey("EnvCompletionDateTamil"))) {
      prefs.setString("EnvCompletionDateTamil", DateTime.now().toIso8601String());
    }

    String storedUserName = prefs.getString('user_name') ?? "பயனர்";

    setState(() {
      topicProgress = progress;
      allTopicsCompleted = allCompleted;
      userName = storedUserName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFC),
      appBar: AppBar(
        title: Text("🌱 சுற்றுச்சூழல் மற்றும் ஆற்றல் சேமிப்பு"),
        backgroundColor: Colors.green[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => BookSelectionPage()),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
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
                icon: Icon(Icons.workspace_premium),
                label: Text("சான்றிதழ் உருவாக்கு"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CertificatePage(
                        userName: userName,
                        topicProgress: topicProgress,
                        bookId: "Environmental Safety",
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
    int completedTopics = topicProgress.values.where((topic) => topic["completed"] == true && topic["score"] >= 3).length;
    int totalTopics = topics.length;
    double progress = completedTopics / totalTopics;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("முன்னேற்றம்: $completedTopics / $totalTopics", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
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
    bool isAccessible = currentIndex == 0;

    if (currentIndex > 0) {
      final prevKey = topics[currentIndex - 1]["key"];
      final prevCompleted = topicProgress[prevKey]?['completed'] ?? false;
      final prevScore = topicProgress[prevKey]?['score'] ?? -1;
      isAccessible = prevCompleted && prevScore >= 3;
    }

    final statusText = quizScore >= 0
        ? "✅ மதிப்பெண்: $quizScore / 5"
        : isCompleted
        ? "✔ முடிக்கப்பட்டது"
        : "🔴 முடியவில்லை";

    final statusColor = quizScore >= 0 ? Colors.green : isCompleted ? Colors.blue : Colors.red;

    return Opacity(
      opacity: isAccessible ? 1.0 : 0.5,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title.split('\n')[0], style: TextStyle(fontSize: 14, color: Colors.green[900], fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(title.split('\n')[1], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
          ),
          trailing: Icon(isAccessible ? Icons.arrow_forward_ios : Icons.lock, color: isAccessible ? Colors.black54 : Colors.grey),
          onTap: isAccessible
              ? () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => page)).then((_) => _loadTopicProgress());
          }
              : () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("முந்தைய தலைப்பை குறைந்தபட்சம் 3 மதிப்பெண்களுடன் முடிக்க வேண்டும்.")),
            );
          },
        ),
      ),
    );
  }
}
