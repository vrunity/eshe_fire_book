// center_of_gravity.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/english/forklift_safety_english.dart';

class CenterOfGravityPage extends StatefulWidget {
  @override
  _CenterOfGravityPageState createState() => _CenterOfGravityPageState();
}

class _CenterOfGravityPageState extends State<CenterOfGravityPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "CenterOfGravity";

  final Map<int, String> correctAnswers = {
    1: "It refers to the point where the load's weight is balanced.",
    2: "It ensures the forklift doesn’t tip over during operation.",
    3: "Triangle formed by front wheels and center of rear axle.",
    4: "Load center is the distance from the vertical face of forks to load’s center of gravity.",
    5: "Exceeding it can make the forklift unstable."
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What does 'center of gravity' mean in forklift use?",
      "options": [
        "Top of the load",
        "Where operator sits",
        "It refers to the point where the load's weight is balanced.",
        "Wheels alignment"
      ]
    },
    {
      "question": "Why is understanding center of gravity important?",
      "options": [
        "For decoration",
        "To lift faster",
        "It ensures the forklift doesn’t tip over during operation.",
        "To save fuel"
      ]
    },
    {
      "question": "What is the stability triangle?",
      "options": [
        "Forks and mast",
        "Operator cabin",
        "Triangle formed by front wheels and center of rear axle.",
        "Battery and engine"
      ]
    },
    {
      "question": "What is load center in forklifts?",
      "options": [
        "Weight of load",
        "Fork length",
        "Height of lift",
        "Load center is the distance from the vertical face of forks to load’s center of gravity."
      ]
    },
    {
      "question": "What happens if load center is exceeded?",
      "options": [
        "Better speed",
        "More lifting capacity",
        "Exceeding it can make the forklift unstable.",
        "Smooth ride"
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isCompleted = prefs.getBool('Completed_\$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_\$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_\$topicName') ?? false;
    });
  }

  Future<void> _saveCompletion(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_\$topicName', value);
    setState(() {
      isCompleted = value;
    });
    if (value) _showQuizDialog();
  }

  Future<void> _saveQuizScore(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('QuizScore_\$topicName', score);
    await prefs.setBool('QuizTaken_\$topicName', true);
    setState(() {
      quizScore = score;
      hasTakenQuiz = true;
    });
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

  void _showQuizDialog() {
    userAnswers.clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Quiz: Center of Gravity & Stability"),
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
                  Navigator.pushNamed(context, '/common_accidents_en');
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

  Widget _buildQA(String question, String answer, {String? imagePath}) {
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
                child: Image.asset(imagePath, fit: BoxFit.cover, height: 180, width: double.infinity),
              ),
            if (imagePath != null) SizedBox(height: 10),
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text(answer, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Centre of Gravity & Stability"),
        backgroundColor: Colors.orange[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ForkliftSafetyEnglish()),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQA("⚖️ What is Center of Gravity?", "It is the point where the weight of an object is evenly balanced.", imagePath: 'assets/forklift_2.0.png'),
                  _buildQA("🔺 What is the Stability Triangle?", "A triangle formed by the front wheels and center of the rear axle that helps define the forklift’s balance."),
                  _buildQA("📏 What is Load Center?", "Distance from the vertical face of forks to load's center of gravity.", imagePath: 'assets/forklift_2.1.png'),
                  _buildQA("🚫 Risk of Exceeding Load Center?", "Forklift may tip over or become unstable."),
                  _buildQA("📦 Why Stability is Crucial?", "It prevents accidents and ensures safe operation.", imagePath: 'assets/forklift_2.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("Mark as Completed"),
              value: isCompleted,
              onChanged: (value) {
                _saveCompletion(value ?? false);
              },
            ),
            if (hasTakenQuiz)
              Text("Last Quiz Score: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(onPressed: _showQuizDialog, child: Text("Retest")),
          ],
        ),
      ),
    );
  }
}
