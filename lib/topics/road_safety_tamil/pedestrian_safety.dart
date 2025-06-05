import 'package:e_she_book/english/road_safety_english.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PedestrianSafetyPage extends StatefulWidget {
  @override
  _PedestrianSafetyPageState createState() => _PedestrianSafetyPageState();
}

class _PedestrianSafetyPageState extends State<PedestrianSafetyPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "PedestrianSafety";

  final Map<int, String> correctAnswers = {
    1: "Sidewalks and crossings",
    2: "Look both ways for traffic",
    3: "Zebra crossings or pedestrian signals",
    4: "Using phones",
    5: "Wear bright clothing",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {"question": "What should pedestrians always use?", "options": ["Sidewalks and crossings", "Road shoulders", "Middle of the road", "Bike lanes"]},
    {"question": "What to do before crossing a street?", "options": ["Look both ways for traffic", "Just run across", "Close eyes and cross", "Wait for someone else"]},
    {"question": "Where should you cross the road?", "options": ["Zebra crossings or pedestrian signals", "Anywhere", "Behind parked cars", "Middle of intersections"]},
    {"question": "What should pedestrians avoid while crossing?", "options": ["Using phones", "Looking around", "Holding hands", "Carrying bags"]},
    {"question": "What is safer for pedestrians at night?", "options": ["Wear bright clothing", "Wear dark clothes", "Hide behind bushes", "Walk on the road"]},
  ];

  @override
  void initState() {
    super.initState();
    _loadTopicStatus();
  }

  Future<void> _loadTopicStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isCompleted = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _saveTopicCompletion(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicName', value);
    setState(() {
      isCompleted = value;
    });
    if (value) _showQuizDialog();
  }

  Future<void> _saveQuizScore(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('QuizScore_$topicName', score);
    await prefs.setBool('QuizTaken_$topicName', true);
    setState(() {
      quizScore = score;
      hasTakenQuiz = true;
    });
  }

  void _showQuizDialog() {
    userAnswers.clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Pedestrian Safety Quiz"),
              content: SingleChildScrollView(
                child: Column(
                  children: quizQuestions.map((question) {
                    int questionIndex = quizQuestions.indexOf(question) + 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(question["question"], style: TextStyle(fontWeight: FontWeight.bold)),
                        ...question["options"].map<Widget>((option) {
                          return RadioListTile<String>(
                            title: Text(option),
                            value: option,
                            groupValue: userAnswers[questionIndex],
                            onChanged: (String? value) {
                              setState(() {
                                userAnswers[questionIndex] = value!;
                              });
                            },
                          );
                        }).toList(),
                      ],
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  child: Text("Submit"),
                  onPressed: () {
                    if (userAnswers.length < quizQuestions.length) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please answer all questions")),
                      );
                    } else {
                      Navigator.pop(dialogContext);
                      _evaluateQuiz();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _evaluateQuiz() {
    int score = 0;
    userAnswers.forEach((key, value) {
      if (correctAnswers[key] == value) {
        score++;
      }
    });
    _saveQuizScore(score);
    _showQuizResult(score);
  }

  void _showQuizResult(int score) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Quiz Result"),
          content: Text("You scored $score out of ${quizQuestions.length}."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
            if (score >= 3)
              TextButton(
                child: Text("Next Topic"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/vehicle_safety_en');
                },
              ),
            TextButton(
              child: Text("Retest"),
              onPressed: () {
                Navigator.pop(context);
                _showQuizDialog();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF4500), Color(0xFF5B0000)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => RoadSafetyEnglish()),
              );
            },
          ),
          title: Text("Pedestrian Safety")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🚶 Where should pedestrians walk?", "Always use sidewalks and crossings.", imagePath: 'assets/road_3.0.png'),
                  _buildQuestionAnswer("🚶 Before crossing the road?", "Look both ways carefully."),
                  _buildQuestionAnswer("🚶 Where to cross safely?", "Use zebra crossings or pedestrian signals.", imagePath: 'assets/road_3.1.png'),
                  _buildQuestionAnswer("🚶 What should you avoid while crossing?", "Avoid using phones while crossing."),
                  _buildQuestionAnswer("🚶 Nighttime pedestrian safety?", "Wear bright clothing.", imagePath: 'assets/road_3.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("Mark as Completed"),
              value: isCompleted,
              onChanged: (value) {
                _saveTopicCompletion(value ?? false);
              },
            ),
            if (hasTakenQuiz)
              Text("Last Quiz Score: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(
                onPressed: _showQuizDialog,
                child: Text("Retest"),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionAnswer(String question, String answer, {String? imagePath}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                ),
              ),
            if (imagePath != null)
              SizedBox(height: 12),
            Text(
              question,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 6),
            Text(
              answer,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
