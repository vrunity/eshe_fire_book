// home_safety_tamil.dart

import 'package:e_she_book/book_selection_page.dart';
import 'package:e_she_book/certificate_page.dart';
import 'package:e_she_book/topics/home_safety_tamil/home_electrical_safety.dart';
import 'package:e_she_book/topics/home_safety_tamil/home_safety_intro.dart';
import 'package:e_she_book/topics/home_safety_tamil/kids_safety_home.dart';
import 'package:e_she_book/topics/home_safety_tamil/kitchen_safety.dart';
import 'package:e_she_book/topics/home_safety_tamil/lpg_safety.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeSafetyTamil extends StatefulWidget {
  @override
  State<HomeSafetyTamil> createState() => _HomeSafetyTamilState();
}

class _HomeSafetyTamilState extends State<HomeSafetyTamil> {
  Map<String, dynamic> topicProgress = {};
  bool allTopicsCompleted = false;
  String userName = "";

  final List<Map<String, dynamic>> topics = [
    {
      "title": "அத்தியாயம் 1\nவீட்டு பாதுகாப்பு அறிமுகம்",
      "page": HomeSafetyIntroTamilPage(),
      "key": "HomeSafetyIntro"
    },
    {
      "title": "அத்தியாயம் 2\nமுகாமை பாதுகாப்பு",
      "page": KitchenSafetyTamilPage(),
      "key": "KitchenSafety"
    },
    {
      "title": "அத்தியாயம் 3\nஎல்.பி.ஜி பாதுகாப்பு",
      "page": LPGSafetyTamilPage(),
      "key": "LPGSafety"
    },
    {
      "title": "அத்தியாயம் 4\nமின்சார பாதுகாப்பு",
      "page": ElectricalSafetyTamilPage(),
      "key": "HomeElectricalSafety"
    },
    {
      "title": "அத்தியாயம் 5\nவீட்டில் குழந்தைகளின் பாதுகாப்பு",
      "page": KidsSafetyTamilPage(),
      "key": "KidsSafetyHome"
    }

  ];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
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

    String storedUser = prefs.getString('user_name') ?? "பயனர்";

    setState(() {
      topicProgress = progress;
      allTopicsCompleted = allCompleted;
      userName = storedUser;
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BookSelectionPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F5FA),
      appBar: AppBar(
        title: Text("🏠 வீட்டு பாதுகாப்பு - வகுப்பு", style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BookSelectionPage()))),
        actions: [IconButton(icon: Icon(Icons.logout), onPressed: _logout)],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orangeAccent, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildProgressBar(),
          Expanded(
            child: ListView.builder(
              itemCount: topics.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final topic = topics[index];
                final key = topic["key"];
                final isDone = topicProgress[key]?["completed"] ?? false;
                final score = topicProgress[key]?["score"] ?? -1;

                return _buildTopicCard(topic["title"], topic["page"], isDone, score, key, index);
              },
            ),
          ),
          if (allTopicsCompleted)
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton.icon(
                icon: Icon(Icons.workspace_premium, color: Colors.white),
                label: Text("சான்றிதழ் பெறவும்", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
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
                        bookId: "Home Safety Tamil",
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
    int completed = topicProgress.values.where((t) => t["completed"] == true).length;
    int total = topics.length;
    double progress = completed / total;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("முன்னேற்றம்: $completed / $total", style: TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _buildTopicCard(String title, Widget page, bool isCompleted, int score, String key, int index) {
    bool isAccessible = index == 0 || (topicProgress[topics[index - 1]["key"]]?["completed"] == true && topicProgress[topics[index - 1]["key"]]?["score"] >= 3);

    final statusText = score >= 0
        ? "✅ மதிப்பெண்: $score / 5"
        : isCompleted
        ? "✔ முடிக்கப்பட்டது"
        : "🔴 முடிக்கவில்லை";

    final statusColor = score >= 0 ? Colors.green : (isCompleted ? Colors.blue : Colors.redAccent);

    return Opacity(
      opacity: isAccessible ? 1.0 : 0.5,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title.split('\n')[0], style: TextStyle(fontSize: 14, color: Colors.deepOrange, fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Text(title.split('\n')[1], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
          ),
          trailing: Icon(isAccessible ? Icons.arrow_forward_ios : Icons.lock, color: isAccessible ? Colors.black : Colors.grey),
          onTap: isAccessible
              ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)).then((_) => _loadProgress())
              : () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("முந்தைய தலைப்பை முழுமையாக முடிக்கவும் (குறைந்தது 3 மதிப்பெண்)"))),
        ),
      ),
    );
  }
}
