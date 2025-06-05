import 'package:e_she_book/book_selection_page.dart';
import 'package:e_she_book/certificate_page.dart';
import 'package:e_she_book/title_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/welcome.dart';

import 'package:e_she_book/topics/fire_safety_english/common_causes.dart' as commonCauses;
import 'package:e_she_book/topics/fire_safety_english/fire_emergency.dart' as fireEmergency;
import 'package:e_she_book/topics/fire_safety_english/fire_safety.dart' as fireSafety;
import 'package:e_she_book/topics/fire_safety_english/fire_extinguishers.dart' as fireExtinguishers;
import 'package:e_she_book/topics/fire_safety_english/fire_prevention.dart' as firePrevention;
import 'package:e_she_book/topics/fire_safety_english/first_aid.dart' as firstAid;
import 'package:e_she_book/topics/fire_safety_english/handling_extinguishers.dart' as handlingExtinguishers;
import 'package:e_she_book/topics/fire_safety_english/industrial_safety.dart' as industrialSafety;

class fire_safety_english extends StatefulWidget {
  @override
  _fire_safety_english_State createState() => _fire_safety_english_State();
}

class _fire_safety_english_State extends State<fire_safety_english> {
  Map<String, dynamic> topicProgress = {};
  bool allTopicsCompleted = false;
  String userName = "";

  final List<Map<String, dynamic>> topics = [
    {"title": "Chapter-1\nIntroduction to Fire Safety", "page": fireSafety.FireSafetyPage(), "key": "FireSafety"},
    {"title": "Chapter-2\nCommon Causes of Fire", "page": commonCauses.CommonCausesPage(), "key": "CommonCauses"},
    {"title": "Chapter-3\nFire Extinguisher Types & Uses", "page": fireExtinguishers.FireExtinguishersPage(), "key": "FireExtinguishers"},
    {"title": "Chapter-4\nFire Prevention Techniques", "page": firePrevention.FirePreventionPage(), "key": "FirePrevention"},
    {"title": "Chapter-5\nFire Emergency Procedures", "page": fireEmergency.FireEmergencyPage(), "key": "FireEmergency"},
    {"title": "Chapter-6\nHandling Fire Extinguishers", "page": handlingExtinguishers.HandlingExtinguishersPage(), "key": "HandlingExtinguishers"},
    {"title": "Chapter-7\nIndustrial Fire Safety", "page": industrialSafety.IndustrialSafetyPage(), "key": "IndustrialSafety"},
    // {"title": "Chapter-8\nFirst Aid for Fire Injuries", "page": firstAid.FirstAidPage(), "key": "FirstAidForFireInjuries"},
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

      if (!isCompleted || quizScore < 0) {
        allCompleted = false;
      }
    }

    String storedUserName = prefs.getString('user_name') ?? "User";

    setState(() {
      topicProgress = progress;
      allTopicsCompleted = allCompleted;
      userName = storedUserName;
    });
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Welcome()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6F00), Color(0xFFB71C1C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text('📘 Fire Safety - Class Page', style: TextStyle(fontWeight: FontWeight.bold)),
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
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
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
                final isCompleted = topicProgress[key]?["completed"] ?? false;
                final score = topicProgress[key]?["score"] ?? -1;
                return _buildTopicCard(
                  context,
                  topic["title"],
                  topic["page"],
                  isCompleted,
                  score,
                  key,
                );
              },
            ),
          ),
          if (allTopicsCompleted)
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.workspace_premium, color: Colors.white),
                label: const Text(
                  "Generate Certificate",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
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
                        bookId: "Fire Safety",
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


  // ✅ Progress Bar Widget
  Widget _buildProgressBar() {
    int completedTopics = topicProgress.values.where((topic) => topic["completed"] == true).length;
    int totalTopics = topics.length;
    double progress = completedTopics / totalTopics;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Progress: $completedTopics / $totalTopics",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              color: Colors.deepOrange,
              minHeight: 12,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, String title, Widget page, bool isCompleted, int quizScore, String key) {
    final currentIndex = topics.indexWhere((element) => element["key"] == key);
    bool isAccessible = true;

    if (currentIndex > 0) {
      final prevKey = topics[currentIndex - 1]["key"];
      final prevCompleted = topicProgress[prevKey]?["completed"] ?? false;
      final prevScore = topicProgress[prevKey]?["score"] ?? -1;

      if (!prevCompleted || prevScore < 4) {
        isAccessible = false;
      }
    }

    final statusText = quizScore >= 0
        ? "✅ Score: $quizScore / 5"
        : isCompleted
        ? "✔ Marked Complete"
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.split('\n')[0],
                style: const TextStyle(fontSize: 14, color: Colors.deepOrange, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                title.split('\n')[1],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
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
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (_, __, ___) => page,
                transitionsBuilder: (_, anim, __, child) {
                  return SlideTransition(
                    position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(anim),
                    child: child,
                  );
                },
              ),
            ).then((_) => _loadTopicProgress());
          }
              : () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Complete the previous topic with score 4 or above.")),
            );
          },
        ),
      ),
    );
  }
}
