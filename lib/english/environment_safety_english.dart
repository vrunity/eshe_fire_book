import 'package:e_she_book/book_selection_page.dart';
import 'package:e_she_book/topics/environment_safety_english/daily_and_eating_habits.dart';
import 'package:e_she_book/topics/environment_safety_english/energy_saving_and_usage.dart';
import 'package:e_she_book/topics/environment_safety_english/environmental_pollution_types.dart';
import 'package:e_she_book/topics/environment_safety_english/home_and_yard_practices.dart';
import 'package:e_she_book/topics/environment_safety_english/introduction_to_environment.dart';
import 'package:e_she_book/topics/environment_safety_english/save_the_environment.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/certificate_page.dart';

class EnvironmentalSafety extends StatefulWidget {
  @override
  _EnvironmentalSafetyState createState() => _EnvironmentalSafetyState();
}

class _EnvironmentalSafetyState extends State<EnvironmentalSafety> {
  Map<String, dynamic> topicProgress = {};
  bool allTopicsCompleted = false;
  String userName = "";

  final List<Map<String, dynamic>> topics = [
    {"title": "Topic 1\nIntroduction to Environment", "page": IntroductionToEnvironmentPage(), "key": "EnvTopic1"},
    {"title": "Topic 2\nSave the Environment", "page": SaveTheEnvironmentPage(), "key": "EnvTopic2"},
    {"title": "Topic 3\nEnvironmental Pollution Types", "page": EnvironmentalPollutionTypesPage(), "key": "EnvTopic3"},
    {"title": "Topic 4\nDaily & Eating Habits", "page": DailyAndEatingHabitsPage(), "key": "EnvTopic4"},
    {"title": "Topic 5\nHome & Yard Practices", "page": HomeAndYardPracticesPage(), "key": "EnvTopic5"},
    // {"title": "Topic 6\nEnergy Saving & Usage", "page": EnergySavingAndUsagePage(), "key": "EnvTopic6"},
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

    // Save completion date once if all topics are passed
    if (allCompleted && !(prefs.containsKey("EnvCompletionDate"))) {
      prefs.setString("EnvCompletionDate", DateTime.now().toIso8601String());
    }

    String storedUserName = prefs.getString('user_name') ?? "User";
    print("📛 Loaded user name: $storedUserName");

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
        title: Text("🌱 Environment & Energy Saving"),
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
                label: Text("Generate Certificate"),
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
          Text("Progress: $completedTopics / $totalTopics", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        ? "✅ Score: $quizScore / 5"
        : isCompleted
        ? "✔ Marked Complete"
        : "🔴 Not Completed";

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
              SnackBar(content: Text("Complete the previous topic with score 3 or above.")),
            );
          },
        ),
      ),
    );
  }
}
