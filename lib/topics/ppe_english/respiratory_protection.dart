// Flutter page for Topic 5: Respiratory Protection
// Full content, quiz, and logic as per other topics

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RespiratoryProtectionPage extends StatefulWidget {
  @override
  _RespiratoryProtectionPageState createState() => _RespiratoryProtectionPageState();
}

class _RespiratoryProtectionPageState extends State<RespiratoryProtectionPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "RespiratoryProtection";

  final Map<int, String> correctAnswers = {
    1: "To prevent inhalation of hazardous substances",
    2: "Respirators and masks",
    3: "Filter harmful particles and gases",
    4: "Based on the type of exposure risk",
    5: "Clean, store properly, and inspect for wear",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "Why is respiratory protection necessary?",
      "options": [
        "To avoid bad smells",
        "To prevent inhalation of hazardous substances",
        "To warm the air",
        "To hide your face"
      ]
    },
    {
      "question": "Which equipment is used for respiratory protection?",
      "options": [
        "Gloves",
        "Helmets",
        "Respirators and masks",
        "Earplugs"
      ]
    },
    {
      "question": "How do respirators work?",
      "options": [
        "Pump oxygen",
        "Filter harmful particles and gases",
        "Humidify air",
        "Improve breathing"
      ]
    },
    {
      "question": "How do you choose the right respirator?",
      "options": [
        "Based on fashion",
        "Ask a friend",
        "Buy the cheapest",
        "Based on the type of exposure risk"
      ]
    },
    {
      "question": "How should respirators be maintained?",
      "options": [
        "Clean, store properly, and inspect for wear",
        "Wash with bleach",
        "Use until it breaks",
        "Lend to others"
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
    if (value) {
      _showQuizDialog();
    }
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
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Respiratory Protection Quiz"),
              content: SingleChildScrollView(
                child: Column(
                  children: quizQuestions.map((question) {
                    int index = quizQuestions.indexOf(question) + 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(question["question"], style: TextStyle(fontWeight: FontWeight.bold)),
                        ...question["options"].map<Widget>((option) {
                          return RadioListTile<String>(
                            title: Text(option),
                            value: option,
                            groupValue: userAnswers[index],
                            onChanged: (String? value) {
                              setState(() {
                                userAnswers[index] = value!;
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
                      Navigator.of(context).pop();
                      _evaluateQuiz();
                    }
                  },
                )
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
            if (score >= 3) // ✅ Show Next Topic button only if score 3 or above
              TextButton(
                child: Text("Next Topic"),
                onPressed: () {
                  Navigator.pushNamed(context, '/foot_protection_en'); // <-- Your next page route
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
        padding: EdgeInsets.all(12),
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
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 5),
            Text(answer, style: TextStyle(fontSize: 16, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Respiratory Protection")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("😷 What is respiratory protection?", "It includes devices such as respirators and face masks used to protect against inhaling harmful substances.",imagePath: 'assets/ppe_4.0.png'),
                  _buildQuestionAnswer("😷 Why is it important?", "Respiratory hazards like dust, fumes, and gases can cause serious health problems including lung disease."),
                  _buildQuestionAnswer("😷 What types of respiratory PPE exist?", "Disposable masks, half-face respirators, full-face respirators, and supplied-air respirators."),
                  _buildQuestionAnswer("😷 When should it be worn?", "Whenever workers are exposed to harmful dust, chemicals, gases, or lack of oxygen."),
                  _buildQuestionAnswer("😷 Can anyone use any respirator?", "No, proper fit-testing and selection based on hazard are necessary.",imagePath: 'assets/ppe_4.1.png'),
                  _buildQuestionAnswer("😷 How do you check for leaks?", "By performing a seal check before use every time."),
                  _buildQuestionAnswer("😷 Are cloth masks enough for industrial work?", "No, certified respirators should be used for workplace hazards."),
                  _buildQuestionAnswer("😷 How do filters work?", "They trap or neutralize harmful particles, vapors, or gases."),
                  _buildQuestionAnswer("😷 What is a respirator cartridge?", "A replaceable filter that purifies air passing through the respirator.",imagePath: 'assets/ppe_4.2.png'),
                  _buildQuestionAnswer("😷 Who enforces respiratory protection rules?", "Employers and safety officers must implement programs and monitor usage."),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("Mark as Completed"),
              value: isCompleted,
              onChanged: (value) => _saveTopicCompletion(value ?? false),
            ),
            if (hasTakenQuiz)
              Text("Last Quiz Score: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(
                onPressed: _showQuizDialog,
                child: Text("Retest"),
              )
          ],
        ),
      ),
    );
  }
}
