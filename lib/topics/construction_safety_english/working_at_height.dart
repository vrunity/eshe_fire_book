import 'package:e_she_book/english/construction_safety_english.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkingAtHeightPage extends StatefulWidget {
  @override
  _WorkingAtHeightPageState createState() => _WorkingAtHeightPageState();
}

class _WorkingAtHeightPageState extends State<WorkingAtHeightPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "WorkingAtHeight";

  final Map<int, String> correctAnswers = {
    1: "Always use full body harness and lifeline.",
    2: "Conduct safety checks before using ladders or lifts.",
    3: "Avoid working in height during strong winds or rain.",
    4: "Use helmets, nonslip shoes, and secure tools.",
    5: "Report any unsafe platform or fall risk.",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "What should you wear while working at height?",
      "options": [
        "Always use full body harness and lifeline.",
        "Just wear a cap.",
        "Wear regular shoes.",
        "No equipment needed."
      ]
    },
    {
      "question": "Before climbing, what is necessary?",
      "options": [
        "Conduct safety checks before using ladders or lifts.",
        "Check phone battery.",
        "Take selfies.",
        "Shout warnings."
      ]
    },
    {
      "question": "When should you avoid working at height?",
      "options": [
        "Avoid working in height during strong winds or rain.",
        "Always work, weather doesn't matter.",
        "Work only at night.",
        "In full sunlight."
      ]
    },
    {
      "question": "What should you wear for safety?",
      "options": [
        "Use helmets, nonslip shoes, and secure tools.",
        "Colorful clothes.",
        "Loose slippers.",
        "Only gloves."
      ]
    },
    {
      "question": "If you see fall hazard, what to do?",
      "options": [
        "Report any unsafe platform or fall risk.",
        "Ignore and continue.",
        "Ask friend to fix.",
        "Wait for someone else."
      ]
    },
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
              title: Text("Working at Height Quiz"),
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
                  // Replace with actual next route
                  // Navigator.pushNamed(context, '/next_topic');
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
                child: Image.asset(imagePath, fit: BoxFit.cover, height: 180, width: double.infinity),
              ),
            if (imagePath != null) SizedBox(height: 10),
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 6),
            Text(answer, style: TextStyle(fontSize: 16, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove shadow for clean UI
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF4500), Color(0xFF5B0000)], // Red to Dark Maroon
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28), // Back Arrow
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ConstructionSafetyEnglish()),
            );
          },
        ),
        title: Text("Working at Height"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🧍 Why use safety gear at height?",
                      "Wearing full-body harness with lifeline prevents falling.", imagePath: 'assets/construction_4.0.png'),
                  _buildQuestionAnswer("✅ What to do before climbing?",
                      "Inspect ladders, platforms, and anchor points first."),
                  _buildQuestionAnswer("🌪 When should you stop work?",
                      "Do not work at height during strong wind or rain.", imagePath: 'assets/constuction_4.1.png'),
                  _buildQuestionAnswer("👷‍♂️ What PPE is needed?",
                      "Helmet, grip shoes, secured tools and reflective vests."),
                  _buildQuestionAnswer("🚨 What to do if risk is spotted?",
                      "Report platform damage or loose parts to site head.", imagePath: 'assets/construction_4.2.png'),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("Mark as Completed"),
              value: isCompleted,
              onChanged: (value) => _saveTopicCompletion(value ?? false),
            ),
            if (hasTakenQuiz) Text("Last Quiz Score: $quizScore / ${quizQuestions.length}"),
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
}
